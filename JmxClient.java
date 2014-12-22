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
/**
 * Class JVMRuntimeClient - Shows how to programmatically connect to
 * a running VM and interact with its RuntimeMXBean.
 *
 * @author Sun Microsystems, 2007 - All rights reserved.
 */
public class JmxClient {
	public static void main(String[] args) throws Exception {
		JmxClient cli=new JmxClient( args[0], Integer.parseInt(args[1]) );
		cli.connect();
		cli.invoke(args[2], args[3]);	
		cli.disconnect();
	}

	private int port=7191; 
	private String host="localhost";
	private JMXConnector connector;

	public JmxClient(String host, int port) {
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

	public void printOperations(String objPattern) throws Exception {
		MBeanServerConnection remote = connector.getMBeanServerConnection();
		ObjectName jmxObj= new ObjectName(objPattern);
		
		MBeanInfo info= remote.getMBeanInfo (jmxObj);
		MBeanOperationInfo[] operations=info.getOperations();
		for ( MBeanOperationInfo operation: operations) {
			System.out.println(operation.getReturnType()+" : "+operation.getName()); 
		}
	}
	public void invoke(String objPattern, String name) throws Exception {
		MBeanServerConnection remote = connector.getMBeanServerConnection();
		ObjectName jmxObj= new ObjectName(objPattern);

		//System.out.println("\nBefore "+name+ " call");	
		remote.invoke(jmxObj, name, new Object[]{}, new String[]{});	
		//System.out.println("After "+name+ " call");	
	}
}

