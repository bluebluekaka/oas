package com.oas.common;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.SQLFeatureNotSupportedException;
import java.util.logging.Logger;

import javax.sql.DataSource;

public class PooledDataSource
  implements DataSource
{
  private String alias;

  public Connection getConnection()
    throws SQLException
  {
    return DriverManager.getConnection(this.alias);
  }

  public Connection getConnection(String username, String password) throws SQLException {
    throw new SQLException("Not implemented");
  }

  public PrintWriter getLogWriter() throws SQLException {
    return new PrintWriter(System.out);
  }

  public void setLogWriter(PrintWriter out) throws SQLException {
  }

  public void setLoginTimeout(int seconds) throws SQLException {
  }

  public int getLoginTimeout() throws SQLException {
    return 0;
  }

  public <T> T unwrap(Class<T> iface) throws SQLException {
    return null;
  }

  public boolean isWrapperFor(Class<?> iface) throws SQLException {
    return false;
  }

  public void setAlias(String alias0) {
    this.alias = "proxool." + alias0;
  }

  public Logger getParentLogger() throws SQLFeatureNotSupportedException {
    return null;
  }
}