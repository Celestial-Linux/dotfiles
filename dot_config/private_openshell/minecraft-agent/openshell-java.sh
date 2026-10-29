# Make Java trust the per-sandbox OpenShell proxy CA and use IPv4 sockets
# (the transparent proxy does not match IPv4-mapped IPv6 connections).
# DNS caching is disabled because policy DNS mappings expire after ~30s and
# Java would otherwise reconnect to a stale synthetic address. Gradle's pooled
# connections get a 1s lifetime because the sandbox relays at most 96 TCP
# streams and its per-repository pools would otherwise hold them all.
_os_ca=/run/openshell-supervisor-ca/material/ca.crt
_os_ts=/tmp/openshell-java-cacerts.p12
if [ -r "$_os_ca" ] && [ -z "${OPENSHELL_JAVA_TRUSTSTORE:-}" ]; then
    if [ ! -s "$_os_ts" ]; then
        cp /etc/pki/java/cacerts "$_os_ts.tmp" && chmod 600 "$_os_ts.tmp" \
            && JAVA_TOOL_OPTIONS= keytool -importcert -noprompt -alias openshell-sandbox-ca \
                -file "$_os_ca" -keystore "$_os_ts.tmp" -storepass changeit >/dev/null 2>&1 \
            && mv "$_os_ts.tmp" "$_os_ts"
    fi
    if [ -s "$_os_ts" ]; then
        export OPENSHELL_JAVA_TRUSTSTORE="$_os_ts"
        export JAVA_TOOL_OPTIONS="-Djava.net.preferIPv4Stack=true -Dsun.net.inetaddr.ttl=0 -Dorg.gradle.internal.http.idleConnectionTimeout=1000 -Djavax.net.ssl.trustStore=$_os_ts -Djavax.net.ssl.trustStorePassword=changeit${JAVA_TOOL_OPTIONS:+ $JAVA_TOOL_OPTIONS}"
    fi
fi
unset _os_ca _os_ts
