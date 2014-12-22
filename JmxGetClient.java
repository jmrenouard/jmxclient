/*
#------------------------------------------------------------------------------
#
# MyRPM - Rpm Utilities
# Copyright (c) Jean-Marie RENOUARD 2014 - LightPath
# Contact : Jean-Marie Renouard <jmrenouard at gmail.com>
#
# This program is open source, licensed under the Artistic Licence v2.0.
#
# Artistic Licence 2.0
# Everyone is permitted to copy and distribute verbatim copies of
# this license document, but changing it is not allowed.
#
#------------------------------------------------------------------------------
 */

import java.io.File;
import java.lang.management.ManagementFactory;
import java.net.InetAddress;
import java.util.logging.Logger;
import javax.management.remote.JMXServiceURL;
import javax.management.MBeanServerConnection;
import javax.management.MBeanInfo;
import javax.management.MBeanParameterInfo;
import javax.management.MBeanOperationInfo;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.ObjectName;
import java.io.IOException;

public class JmxGetClient {
	public static void main(String[] args) throws Exception {
		JmxGetClient cli=new JmxGetClient( args[0], Integer.parseInt(args[1]) );
		cli.connect();
		System.out.println( cli.getJmxAttribute(args[2], args[3]) );
		cli.disconnect();
	}

	private int port=7091; 
	private String host="localhost";
	private JMXConnector connector;

	public JmxGetClient(String host, int port) {
		this.host=host;
		this.port=port;

	}

	public void connect() throws Exception {
		String urlConn="service:jmx:rmi:///jndi/rmi://"+host+":"+port+"/jmxrmi";
		JMXServiceURL target = new JMXServiceURL(urlConn);
		connector = JMXConnectorFactory.connect(target);
	}

	public void disconnect() throws Exception {
		connector.close();
	}
	public String getJmxAttribute(String objPattern, String attr) throws Exception {
		MBeanServerConnection remote = connector.getMBeanServerConnection();
		ObjectName jmxObj= new ObjectName(objPattern);
		String ret;
		try {
			ret=remote.getAttribute(jmxObj, attr).toString();
		} catch (Exception e) {
			ret="-1";
		}
		return ret;
	}
}
