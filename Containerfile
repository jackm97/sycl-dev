FROM ghcr.io/jackm97/my-nvim-ide:rocky-latest as acpp-build

COPY user-init-scripts /tmp/user-init-scripts
RUN cp -r /tmp/user-init-scripts/. /etc/user-init-scripts/
RUN find /etc/user-init-scripts -type f -wholename "/etc/user-init-scripts/*" | xargs chmod +x
RUN mkdir /etc/profile.d.links -p
RUN find /etc/user-init-scripts -type f -wholename "/etc/user-init-scripts/profile.d/*" | xargs -I'{}' ln -sf '{}' /etc/profile.d.links

RUN touch ~/.container_user_is_init
RUN touch ~/.bashrc 
RUN bash --rcfile ~/.bashrc --noprofile -i /etc/user-init-scripts/install_pixi.sh

VOLUME /build
RUN git clone https://github.com/AdaptiveCpp/AdaptiveCpp.git /build/acpp 
RUN cp /etc/project-manifests/cmake-project/pixi.toml /build/acpp/pixi.toml 
COPY scripts/acpp /scripts
RUN cp -r /scripts /build/acpp/scripts

WORKDIR /build/acpp 
RUN ~/.pixi/bin/pixi task add configure 'sh $PIXI_PROJECT_ROOT/scripts/configure.sh'
RUN ~/.pixi/bin/pixi task add build --depends-on=configure 'sh $PIXI_PROJECT_ROOT/scripts/build.sh'
RUN ~/.pixi/bin/pixi task add install --depends-on=build 'sh $PIXI_PROJECT_ROOT/scripts/install.sh' 
RUN ~/.pixi/bin/pixi run install


FROM scratch as acpp-base
COPY --from=acpp-build /etc/project-manifests/acpp-project /etc/project-manifests/acpp-project
COPY --from=acpp-build /usr/local/acpp /usr/local/acpp
COPY --from=acpp-build /etc/profile.d.links/. /etc/profile.d/
COPY --from=acpp-build /etc/user-init-scripts /etc/user-init-scripts

FROM ghcr.io/jackm97/my-nvim-ide:rocky-latest as sycl-dev:acpp-rocky
COPY --from=acpp-base / /

FROM ghcr.io/jackm97/my-nvim-ide:ubu-latest as sycl-dev:acpp-ubu
COPY --from=acpp-base / /
