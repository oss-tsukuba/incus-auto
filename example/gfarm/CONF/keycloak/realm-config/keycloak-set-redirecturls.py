import sys
import msgspec
from keycloak import KeycloakAdmin
from keycloak.exceptions import KeycloakError


class KeycloakConfig(msgspec.Struct):
    keycloak_url: str
    admin_username: str
    admin_password: str
    realm_master: str
    realm: str
    client_secret: str
    jwt_server_urls: list[str]
    verify_cert: bool


class KeycloakRedirectURL(msgspec.Struct):
    client_id: str
    redirect_urls: list[str]


with open(sys.argv[1], 'rb') as f:
    yaml_str = f.read()
config = msgspec.yaml.decode(yaml_str, type=KeycloakConfig)


with open(sys.argv[2], 'rb') as f:
    yaml_str = f.read()
redirect_config = msgspec.yaml.decode(yaml_str, type=KeycloakRedirectURL)

KEYCLOAK_URL = config.keycloak_url
ADMIN_USERNAME = config.admin_username
ADMIN_PASSWORD = config.admin_password
REALM_MASTER = config.realm_master
REALM = config.realm
CLIENT_SECRET = config.client_secret
VERIFY_CERT = config.verify_cert
CLIENT_ID = redirect_config.client_id
REDIRECT_URLS = redirect_config.redirect_urls


def E(*args):
    print('Error:', *args, file=sys.stderr)


try:
    kapi = KeycloakAdmin(
        server_url=KEYCLOAK_URL,
        username=ADMIN_USERNAME,
        password=ADMIN_PASSWORD,
        realm_name=REALM,
        user_realm_name=REALM_MASTER,
        verify=VERIFY_CERT,
    )
except KeycloakError as e:
    E(e.error_message)
    sys.exit(1)

# Get the client
clients = kapi.get_clients()
client = next((c for c in clients if c["clientId"] == CLIENT_ID), None)

if not client:
    raise Exception("Client not found")

# Get full client config
client_data = kapi.get_client(client["id"])

# Update redirect URIs (append if not already present)
redirects = client_data.get("redirectUris", [])
for new_redirect_uri in REDIRECT_URLS:
    if new_redirect_uri not in redirects:
        redirects.append(new_redirect_uri)
        print(f"Added redirect URI: {new_redirect_uri}")
    else:
        print("Redirect URI already exists")

client_data["redirectUris"] = redirects

kapi.update_client(client["id"], client_data)
