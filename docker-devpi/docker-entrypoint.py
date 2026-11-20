import fcntl
import os
import socket
import struct
import subprocess
import sys
from pathlib import Path

SIOCGIFADDR = 0x8915


def get_ipv4(ifname: str) -> str:
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        packed = fcntl.ioctl(
            s.fileno(),
            SIOCGIFADDR,
            struct.pack("256s", ifname[:15].encode()),
        )
    return socket.inet_ntoa(packed[20:24])


def main() -> None:
    serverdir = os.environ.get("DEVPI_SERVERDIR", "/data")

    listen_addresses = []

    if "DEVPI_LISTEN_IFACE" in os.environ:
        listen_addresses.append(get_ipv4(os.environ["DEVPI_LISTEN_IFACE"]))
    if "DEVPI_LISTEN_ADDRESS" in os.environ:
        listen_addresses.append(os.environ["DEVPI_LISTEN_ADDRESS"])

    if not listen_addresses:
        listen_addresses.append("0.0.0.0")
    port = os.environ.get("DEVPI_PORT", "3141")

    if not (Path(serverdir) / ".nodeinfo").is_file():
        print(f"Initialising devpi server directory at {serverdir}", flush=True)
        init_cmd = ["devpi-init", "--serverdir", serverdir]
        password = os.environ.get("DEVPI_INITIAL_ROOT_PASSWORD")
        if password:
            init_cmd += ["--root-passwd", password]
        else:
            print(
                "WARNING: DEVPI_ROOT_PASSWORD not set; root user has an empty password",
                file=sys.stderr,
                flush=True,
            )
        try:
            subprocess.run(init_cmd, check=True)
        except subprocess.CalledProcessError:
            sys.exit(1)

    server_cmd = [
        "devpi-server",
        "--serverdir",
        serverdir,
        *[arg for addr in listen_addresses for arg in ("--listen", f"{addr}:{port}")],
        *sys.argv[1:],
    ]

    os.execvp(server_cmd[0], server_cmd)


if __name__ == "__main__":
    main()
