FROM kasmweb/core-ubuntu-jammy:1.17.0

USER root

ENV HOME=/home/kasm-default-profile \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/dockerstartup/install

WORKDIR $HOME

######### Customize Container Here ###########

RUN wget https://builds.parsec.app/package/parsec-linux.deb \
    && apt-get update \
    && apt-get install -y ./parsec-linux.deb \
    && rm parsec-linux.deb

RUN echo "/usr/bin/desktop_ready && /usr/bin/parsecd &" > $STARTUPDIR/custom_startup.sh \
    && chmod +x $STARTUPDIR/custom_startup.sh

RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* \
        $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/ \
    && apt-get remove -y xfce4-panel

######### End Customizations ###########

RUN chown 1000:0 $HOME \
    && $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME=/home/kasm-user

WORKDIR $HOME

RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000