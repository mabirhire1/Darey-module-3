# Prometheus Node Exporter Setup for Linux Server Monitoring

Monitoring a Linux server is essential for ensuring system health and performance. Prometheus Node Exporter is a powerful tool that collects hardware and operating system metrics, providing deep insights into your server’s state over time. This project will guide you through installing and configuring Prometheus Node Exporter on a Linux server and monitoring it with Prometheus.

## Tasks Outline

- Install and configure Prometheus Node Exporter on a Linux server.
- Integrate Node Exporter with Prometheus for metric collection.
- Explore system metrics collected by Node Exporter.
- Set up basic queries in Prometheus for real-time monitoring.
- Optionally configure alerts for key metrics.

## Prerequisites

- A running Linux server with `sudo` privileges
- A working Prometheus instance (local or remote)
- Network connectivity allowing Prometheus to reach the server on port 9100
- Terminal access to the Linux server
- Text editor access (nano, vim, etc.)
- Basic familiarity with systemd services

## Project Tasks

### Step 1: Download Node Exporter

Download the latest Node Exporter binary from the official Prometheus GitHub releases:

```bash
$ curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
```

### Step 2: Extract and Install

Extract the downloaded archive and move the binary to your system PATH:

```bash
# Extract the tarball
tar -xvf node_exporter-linux-amd64.tar.gz

# Move binary to /usr/local/bin/
sudo mv node_exporter-linux-amd64/node_exporter /usr/local/bin/
```

### Step 3: Create System Service

Create a systemd service file for Node Exporter:

```bash
sudo nano /etc/systemd/system/node_exporter.service
```

Add the following configuration:

```ini
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=nobody
ExecStart=/usr/local/bin/node_exporter
Restart=always
WantedBy=multi-user.target
```

### Step 4: Start and Enable Service

Enable and start the Node Exporter service:

```bash
# Reload systemd configuration
sudo systemctl daemon-reload

# Start the service
sudo systemctl start node_exporter

# Enable auto-start on boot
sudo systemctl enable node_exporter
```

### Step 5: Verify Installation

Check that Node Exporter is running correctly:

```bash
# Check service status
sudo systemctl status node_exporter

# Verify metrics endpoint is accessible
curl http://localhost:9100/metrics | head -20
```
**Output**
ubuntu@ip-172-31-23-56:~$ curl http://localhost:9100/metrics | head -5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0# HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 1.9775e-05

## Configuration

### Configure Prometheus Integration

#### Step 1: Update Prometheus Configuration

Edit your Prometheus configuration file:

```bash
sudo nano /etc/prometheus/prometheus.yml
```

#### Step 2: Add Node Exporter Target

Add the following scrape configuration:

```yaml
scrape_configs:
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['your-server-ip:9100']
```

**Note:** Replace `your-server-ip` with:
- Your actual server IP address for remote monitoring
- `localhost` if Prometheus and Node Exporter are on the same machine

#### Step 3: Restart Prometheus

Apply the configuration changes:

```bash
sudo systemctl restart prometheus
```

## Verification

### Verify Node Exporter Access

1. **Command Line Test:**
   ```bash
   curl http://localhost:9100/metrics | grep "node_cpu"
   ```
2. **Web Browser Test:**
   - Navigate to `http://your-server-ip:9100/metrics`
   - You should see a page with various system metrics
![Web Page](img/image.png) 

### Verify Prometheus Integration

1. **Access Prometheus Web UI:**
   - Navigate to `http://your-server-ip:9090`

2. **Check Targets:**
   - Go to Status → Targets
   - Verify that the `node-exporter` target shows as "UP"

![Targets](img/image1.png)

3. **Test Basic Query:**
   - In the Prometheus query interface, try: `node_cpu_seconds_total`

## Monitoring and Queries

### Essential Metrics to Monitor

#### CPU Usage
```promql
# Current CPU usage rate
rate(node_cpu_seconds_total[5m])

# CPU usage by mode
rate(node_cpu_seconds_total{mode="user"}[5m])
```

#### Memory Monitoring
```promql
# Available memory in bytes
node_memory_MemAvailable_bytes

# Memory usage percentage
100 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100)
```

#### Disk Space
```promql
# Available disk space
node_filesystem_avail_bytes

# Disk usage percentage
100 - (node_filesystem_avail_bytes / node_filesystem_size_bytes * 100)
```

#### Network Traffic
```promql
# Network bytes received
rate(node_network_receive_bytes_total[5m])

# Network bytes transmitted
rate(node_network_transmit_bytes_total[5m])
```

### Sample Queries for Analysis

#### CPU Analysis Over Time
```promql
rate(node_cpu_seconds_total[5m])
```

#### Memory Utilization Trend
```promql
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

#### Disk I/O Operations
```promql
rate(node_disk_reads_completed_total[5m])
rate(node_disk_writes_completed_total[5m])
```

## Troubleshooting

### Common Issues and Solutions

#### Service Won't Start
```bash
# Check service logs
sudo journalctl -u node_exporter -f

# Verify binary permissions
ls -la /usr/local/bin/node_exporter
```

#### Port 9100 Not Accessible
```bash
# Check if port is listening
sudo netstat -tlnp | grep 9100

# Check firewall settings
sudo ufw status
sudo firewall-cmd --list-ports
```

#### Port 9090 Not Accessible
```bash
# Check if port is listening
sudo netstat -tlnp | grep 9090

# Check firewall settings
sudo ufw status
sudo firewall-cmd --list-ports
```

#### Metrics Not Appearing in Prometheus
1. Verify Prometheus configuration syntax:
```bash
promtool check config /etc/prometheus/prometheus.yml
```

2. Check Prometheus logs:
```bash
sudo journalctl -u prometheus -f
```

3. Verify network connectivity:
```bash
telnet your-server-ip 9090
```

### Performance Considerations

- Node Exporter has minimal resource overhead
- Default scrape interval is 15 seconds
- Consider adjusting scrape intervals for high-frequency monitoring
- Monitor Prometheus storage requirements as metrics accumulate

## Next Steps

### Recommended Enhancements

1. **Set Up Alerting:**
   - Configure Alertmanager for critical metric thresholds
   - Create alert rules for high CPU, low memory, or disk space issues

2. **Add Visualization:**
   - Install Grafana for advanced dashboards
   - Import community Node Exporter dashboards

3. **Extend Monitoring:**
   - Add custom metrics using textfile collector
   - Monitor additional services with specific exporters

4. **Security Hardening:**
   - Configure HTTPS for metrics endpoints
   - Implement authentication if needed
   - Restrict network access to monitoring ports

### Useful Resources

- [Prometheus Node Exporter Documentation](https://github.com/prometheus/node_exporter)
- [Prometheus Query Language (PromQL) Guide](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Grafana Node Exporter Dashboard Templates](https://grafana.com/grafana/dashboards/?search=node%20exporter)

