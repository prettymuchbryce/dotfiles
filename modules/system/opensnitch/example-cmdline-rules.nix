# Example OpenSnitch rules using the new cmdLine option
# This demonstrates practical usage of the cmdLine feature
[
  # Allow Python scripts with specific command line patterns
  {
    name = "Allow Python pip installs";
    process = "/usr/bin/python3";
    cmdLine = "python3.*-m pip install";
    host = "^(pypi\\.org|files\\.pythonhosted\\.org)$";
    port = 443;
    protocol = "tcp";
  }

  # Allow Node.js npm commands
  {
    name = "Allow npm registry access";
    cmdLine = "npm.*(install|update|publish)";
    host = "registry\\.npmjs\\.org";
    port = 443;
    protocol = "tcp";
  }

  # Allow git clone commands specifically
  {
    name = "Allow git clone from GitHub";
    cmdLine = "git.*clone.*github\\.com";
    host = "github\\.com";
    port = 443;
    protocol = "tcp";
  }

  # Allow curl with specific user agents or parameters
  {
    name = "Allow curl API requests";
    process = "/usr/bin/curl";
    cmdLine = "curl.*-H.*User-Agent";
    port = 443;
    protocol = "tcp";
  }

  # Allow wget downloads with specific patterns
  {
    name = "Allow wget downloads";
    cmdLine = "wget.*\\.(zip|tar\\.gz|deb|rpm)";
    port = 443;
    protocol = "tcp";
  }
]