# Copyright 2023 Advantech

DESCRIPTION = "AppHub-Edge Support"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd

SRC_URI = "file://AppHub-Edge_1.1.5.tar.gz \
           file://AppHub-Edge.service \
	   file://startup_AppHub-Edge.sh \
" 

S = "${WORKDIR}/AppHub-Edge_1.1.5"

do_install() {	
	install -d ${D}/media/recovery/AppHub-Edge/
    	install -m 755 ${WORKDIR}/startup_AppHub-Edge.sh ${D}/media/recovery/AppHub-Edge/

	# Systemd
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
       	install -d ${D}${systemd_unitdir}/system
		install -m 0644 ${WORKDIR}/AppHub-Edge.service  ${D}${systemd_unitdir}/system
	fi

    	install -m 755 ${S}/AppHub-Edge-ARM64 ${D}/media/recovery/AppHub-Edge/

	install -d ${D}/media/recovery/AppHub-Edge/assets/
	install -m 755 ${S}/assets/index.html ${D}/media/recovery/AppHub-Edge/assets/

	install -d ${D}/media/recovery/AppHub-Edge/assets/static
	install -d ${D}/media/recovery/AppHub-Edge/assets/static/css
	install -m 755 ${S}/assets/static/css/* ${D}/media/recovery/AppHub-Edge/assets/static/css

	install -d ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login
	install -m 755 ${S}/assets/static/ensaas_login/wisepaas-login_template.html ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/

        install -d ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/css
	install -m 755 ${S}/assets/static/ensaas_login/css/wisepaas-login_template.css ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/css
	install -m 755 ${S}/assets/static/ensaas_login/css/wisepaas-login_template_login.css ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/css
	install -d ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/css/fonts
 	install -m 755 ${S}/assets/static/ensaas_login/css/fonts/NotoSans-Regular.ttf ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/css/fonts

	install -d ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/img
        install -m 755 ${S}/assets/static/ensaas_login/img/* ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/img

	install -d ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/libs
	install -d ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/libs/bootstrap
	install -d ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/libs/bootstrap/css
	install -m 755 ${S}/assets/static/ensaas_login/libs/bootstrap/css/* ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/libs/bootstrap/css

	install -d ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/others
	install -m 755 ${S}/assets/static/ensaas_login/others/* ${D}/media/recovery/AppHub-Edge/assets/static/ensaas_login/others
	
        install -d ${D}/media/recovery/AppHub-Edge/assets/static/fonts
        install -m 755 ${S}/assets/static/fonts/* ${D}/media/recovery/AppHub-Edge/assets/static/fonts

	install -d ${D}/media/recovery/AppHub-Edge/assets/static/img
	install -m 755 ${S}/assets/static/img/* ${D}/media/recovery/AppHub-Edge/assets/static/img

	install -d ${D}/media/recovery/AppHub-Edge/assets/static/imgs
	install -m 755 ${S}/assets/static/imgs/* ${D}/media/recovery/AppHub-Edge/assets/static/imgs

 	install -d ${D}/media/recovery/AppHub-Edge/assets/static/js
	install -m 755 ${S}/assets/static/js/* ${D}/media/recovery/AppHub-Edge/assets/static/js

	install -d ${D}/media/recovery/AppHub-Edge/assets/static/json
	install -m 755 ${S}/assets/static/json/config.json ${D}/media/recovery/AppHub-Edge/assets/static/json

	install -d ${D}/media/recovery/AppHub-Edge/conf/
	install -m 755 ${S}/conf/edge.yaml ${D}/media/recovery/AppHub-Edge/conf/
	install -m 755 ${S}/conf/npc.conf ${D}/media/recovery/AppHub-Edge/conf/

	install -m 755 ${S}/dmagent.db ${D}/media/recovery/AppHub-Edge/

	install -d ${D}/media/recovery/AppHub-Edge/edityaml/
	install -m 755 ${S}/edityaml/edityaml-arm64 ${D}/media/recovery/AppHub-Edge/edityaml
}

SYSTEMD_SERVICE_${PN} = "AppHub-Edge.service"

RDEPENDS_${PN} += "bash"

INSANE_SKIP_${PN} = "ldflags"

#List the files for Package
FILES_${PN} += "/media/recovery/AppHub-Edge/"
