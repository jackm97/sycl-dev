FROM ghcr.io/jackm97/my-nvim-ide:rocky-latest as acpp-build

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
COPY --from=acpp-build /etc/user-init-scripts/profile.d/50-setup-user.sh /etc/user-init-scripts/profile.d/50-setup-user.sh
COPY --from=acpp-build /etc/project-manifests /etc/project-manifests
COPY --from=acpp-build /usr/local/acpp /usr/local/acpp

FROM ghcr.io/jackm97/my-nvim-ide:rocky-latest as sycl-dev:acpp-rocky
COPY --from=acpp-base / /

FROM ghcr.io/jackm97/my-nvim-ide:ubu-latest as sycl-dev:acpp-ubu
COPY --from=acpp-base / /
