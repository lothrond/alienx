# user account configuration settings

## Specify system administration user
## This is the only single user created with `make desktop`
## With `make console` this acts as an admin user with root access

# Full geckos username (can contain spaces, etc)
USER_ADMIN_FULL := System Administrator

# Login username
USER_ADMIN := admin

## Specify additional dedicated (steam) gaming user
## This user is only created with `make console`

# Full geckos username (...)
USER_GAME_FULL := SteamOS Gamer

# Login username
USER_GAME := gamer
