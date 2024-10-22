<!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>

  <!-- Our well-known bus type, do not change this -->
  <type>system</type>

  <!-- Fork into daemon mode -->
  <fork/>

  <!-- Write a pid file -->
  <pidfile>/tmp/sdbuscpp.pid</pidfile>

  <!-- Only allow socket-credentials-based authentication -->
  <auth>EXTERNAL</auth>

  <!-- Only listen on a local socket. (abstract=/path/to/socket
       means use abstract namespace, don't really create filesystem
       file; only Linux supports this. Use path=/whatever on other
       systems.) -->
  <listen>unix:path=/tmp/sdbuscpp_bus</listen>

  <policy context="default">
    <!-- All users can connect to system bus -->
    <allow user="*"/>

    <!-- Holes must be punched in service configuration files for
         name ownership and sending method calls -->
    <deny own="*"/>
    <deny send_type="method_call"/>

    <!-- Signals and reply messages (method returns, errors) are allowed
         by default -->
    <allow send_type="signal"/>
    <allow send_requested_reply="true" send_type="method_return"/>
    <allow send_requested_reply="true" send_type="error"/>

    <!-- All messages may be received by default -->
    <allow receive_type="method_call"/>
    <allow receive_type="method_return"/>
    <allow receive_type="error"/>
    <allow receive_type="signal"/>

    <!-- Allow anyone to talk to the message bus -->
    <allow send_destination="org.freedesktop.DBus"
           send_interface="org.freedesktop.DBus" />
    <allow send_destination="org.freedesktop.DBus"
           send_interface="org.freedesktop.DBus.Introspectable"/>
    <allow send_destination="org.freedesktop.DBus"
           send_interface="org.freedesktop.DBus.Properties"/>
    <allow send_destination="org.freedesktop.DBus"
           send_interface="org.freedesktop.DBus.Containers1"/>
    <!-- But disallow some specific bus services -->
    <deny send_destination="org.freedesktop.DBus"
          send_interface="org.freedesktop.DBus"
          send_member="UpdateActivationEnvironment"/>
    <deny send_destination="org.freedesktop.DBus"
          send_interface="org.freedesktop.DBus.Debug.Stats"/>
    <deny send_destination="org.freedesktop.DBus"
          send_interface="org.freedesktop.systemd1.Activator"/>
  </policy>

  <!-- Only systemd, which runs as root, may report activation failures. -->
  <policy user="root">
    <allow send_destination="org.freedesktop.DBus"
           send_interface="org.freedesktop.systemd1.Activator"/>
  </policy>

  <!-- root may monitor the system bus. -->
  <policy user="root">
    <allow send_destination="org.freedesktop.DBus"
           send_interface="org.freedesktop.DBus.Monitoring"/>
  </policy>

  <!-- If the Stats interface was enabled at compile-time, root may use it.
       Copy this into system.local.conf or system.d/*.conf if you want to
       enable other privileged users to view statistics and debug info -->
  <policy user="root">
    <allow send_destination="org.freedesktop.DBus"
           send_interface="org.freedesktop.DBus.Debug.Stats"/>
  </policy>

  <!-- Include legacy configuration location -->
  <include ignore_missing="yes">/etc/dbus-1/system.conf</include>

  <includedir>CURDIR/tests/integrationtests/files/</includedir>
</busconfig>
