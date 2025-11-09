#!/bin/bash

# Interactive PostgreSQL Database Creation Script
# Membuat database dan user PostgreSQL dengan menu interaktif dan validasi lengkap

set -e

# Configuration
CONTAINER_NAME=${POSTGRES_CONTAINER_NAME:-postgres}
ADMIN_USER="helmipradita"
POSTGRES_DB="postgres"

# Color codes untuk output yang lebih menarik
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Reserved PostgreSQL names yang tidak boleh digunakan
RESERVED_NAMES=("postgres" "template0" "template1" "pg_catalog" "information_schema" "public")

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

print_header() {
    echo -e "\n${CYAN}${BOLD}========================================${NC}"
    echo -e "${CYAN}${BOLD}  PostgreSQL Interactive DB Creator${NC}"
    echo -e "${CYAN}${BOLD}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_section() {
    echo -e "\n${BOLD}${BLUE}=== $1 ===${NC}"
}

# Check if PostgreSQL container is running
check_container() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        print_error "PostgreSQL container '$CONTAINER_NAME' is not running!"
        print_info "Start container with: docker-compose up -d"
        exit 1
    fi
    print_success "PostgreSQL container is running"
}

# Execute SQL command in PostgreSQL container
execute_sql() {
    local sql="$1"
    docker exec "$CONTAINER_NAME" psql -U "$ADMIN_USER" -d "$POSTGRES_DB" -t -A -c "$sql" 2>&1
}

# Execute SQL command quietly (no output)
execute_sql_quiet() {
    local sql="$1"
    docker exec "$CONTAINER_NAME" psql -U "$ADMIN_USER" -d "$POSTGRES_DB" -t -A -c "$sql" > /dev/null 2>&1
}

# Check if user exists in PostgreSQL
user_exists() {
    local username="$1"
    local result=$(execute_sql "SELECT 1 FROM pg_roles WHERE rolname='$username';")
    [[ "$result" == "1" ]]
}

# Check if database exists in PostgreSQL
database_exists() {
    local dbname="$1"
    local result=$(execute_sql "SELECT 1 FROM pg_database WHERE datname='$dbname';")
    [[ "$result" == "1" ]]
}

# Validate username
validate_username() {
    local username="$1"

    # Check if empty
    if [[ -z "$username" ]]; then
        print_error "Username cannot be empty"
        return 1
    fi

    # Check length (PostgreSQL max identifier length is 63)
    if [[ ${#username} -gt 63 ]]; then
        print_error "Username too long (max 63 characters)"
        return 1
    fi

    # Check if reserved name
    for reserved in "${RESERVED_NAMES[@]}"; do
        if [[ "$username" == "$reserved" ]]; then
            print_error "Username '$username' is a reserved PostgreSQL name"
            return 1
        fi
    done

    # Check valid characters (lowercase letters, numbers, underscore)
    if [[ ! "$username" =~ ^[a-z_][a-z0-9_]*$ ]]; then
        print_error "Username must start with lowercase letter or underscore, and contain only lowercase letters, numbers, and underscores"
        return 1
    fi

    return 0
}

# Validate database name
validate_database_name() {
    local dbname="$1"

    # Check if empty
    if [[ -z "$dbname" ]]; then
        print_error "Database name cannot be empty"
        return 1
    fi

    # Check length
    if [[ ${#dbname} -gt 63 ]]; then
        print_error "Database name too long (max 63 characters)"
        return 1
    fi

    # Check if reserved name
    for reserved in "${RESERVED_NAMES[@]}"; do
        if [[ "$dbname" == "$reserved" ]]; then
            print_error "Database name '$dbname' is a reserved PostgreSQL name"
            return 1
        fi
    done

    # Check valid characters
    if [[ ! "$dbname" =~ ^[a-z_][a-z0-9_]*$ ]]; then
        print_error "Database name must start with lowercase letter or underscore, and contain only lowercase letters, numbers, and underscores"
        return 1
    fi

    return 0
}

# Validate password strength
validate_password() {
    local password="$1"

    # Check minimum length
    if [[ ${#password} -lt 8 ]]; then
        print_error "Password must be at least 8 characters long"
        return 1
    fi

    # Check for uppercase letter
    if [[ ! "$password" =~ [A-Z] ]]; then
        print_error "Password must contain at least one uppercase letter"
        return 1
    fi

    # Check for lowercase letter
    if [[ ! "$password" =~ [a-z] ]]; then
        print_error "Password must contain at least one lowercase letter"
        return 1
    fi

    # Check for number
    if [[ ! "$password" =~ [0-9] ]]; then
        print_error "Password must contain at least one number"
        return 1
    fi

    return 0
}

# ============================================================================
# USER MANAGEMENT FUNCTIONS
# ============================================================================

# List all existing PostgreSQL users
list_users() {
    print_section "Existing PostgreSQL Users"

    local users=$(execute_sql "SELECT rolname FROM pg_roles WHERE rolcanlogin=true ORDER BY rolname;")

    if [[ -z "$users" ]]; then
        print_warning "No users found"
        return 1
    fi

    local i=1
    echo "$users" | while IFS= read -r user; do
        echo -e "${CYAN}[$i]${NC} $user"
        ((i++))
    done

    return 0
}

# Get user choice from existing users
select_existing_user() {
    local users=$(execute_sql "SELECT rolname FROM pg_roles WHERE rolcanlogin=true ORDER BY rolname;")
    local user_array=()

    while IFS= read -r user; do
        user_array+=("$user")
    done <<< "$users"

    if [[ ${#user_array[@]} -eq 0 ]]; then
        print_error "No existing users found"
        return 1
    fi

    echo ""
    echo -e "${BOLD}Select user:${NC}"
    for i in "${!user_array[@]}"; do
        echo -e "${CYAN}[$((i+1))]${NC} ${user_array[$i]}"
    done
    echo -e "${CYAN}[0]${NC} Cancel"

    while true; do
        echo -n -e "\n${BOLD}Enter choice [0-${#user_array[@]}]: ${NC}"
        read choice

        if [[ "$choice" == "0" ]]; then
            return 1
        fi

        if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le ${#user_array[@]} ]]; then
            SELECTED_USER="${user_array[$((choice-1))]}"
            print_success "Selected user: $SELECTED_USER"
            return 0
        fi

        print_error "Invalid choice. Please enter a number between 0 and ${#user_array[@]}"
    done
}

# Create new PostgreSQL user
create_new_user() {
    print_section "Create New User"

    local username=""
    local password=""
    local password_confirm=""

    # Get username
    while true; do
        echo -n -e "\n${BOLD}Enter username: ${NC}"
        read username

        if validate_username "$username"; then
            if user_exists "$username"; then
                print_error "User '$username' already exists"
                continue
            fi
            break
        fi
    done

    # Get password
    while true; do
        echo -n -e "${BOLD}Enter password (min 8 chars, must have uppercase, lowercase, number): ${NC}"
        read -s password
        echo ""

        if ! validate_password "$password"; then
            continue
        fi

        echo -n -e "${BOLD}Confirm password: ${NC}"
        read -s password_confirm
        echo ""

        if [[ "$password" != "$password_confirm" ]]; then
            print_error "Passwords do not match"
            continue
        fi

        break
    done

    # Get user permissions
    local permissions=$(select_user_permissions)

    # Create user
    print_info "Creating user '$username'..."

    local create_sql="CREATE USER \"$username\" WITH PASSWORD '$password' $permissions;"

    if execute_sql_quiet "$create_sql"; then
        print_success "User '$username' created successfully"
        SELECTED_USER="$username"
        USER_PASSWORD="$password"
        return 0
    else
        print_error "Failed to create user '$username'"
        return 1
    fi
}

# Select user permissions (advanced)
select_user_permissions() {
    print_section "Select User Permissions"

    echo -e "${BOLD}Choose permission level:${NC}"
    echo -e "${CYAN}[1]${NC} SUPERUSER (Full access to all databases - use with caution)"
    echo -e "${CYAN}[2]${NC} CREATEDB + LOGIN (Can create databases and login - recommended)"
    echo -e "${CYAN}[3]${NC} LOGIN only (Basic user, can only access granted databases)"
    echo -e "${CYAN}[4]${NC} Custom (Select specific permissions)"

    while true; do
        echo -n -e "\n${BOLD}Enter choice [1-4]: ${NC}"
        read perm_choice

        case $perm_choice in
            1)
                echo "SUPERUSER LOGIN"
                return
                ;;
            2)
                echo "CREATEDB LOGIN"
                return
                ;;
            3)
                echo "LOGIN"
                return
                ;;
            4)
                select_custom_permissions
                return
                ;;
            *)
                print_error "Invalid choice"
                ;;
        esac
    done
}

# Select custom user permissions
select_custom_permissions() {
    local perms=("LOGIN")

    echo -e "\n${BOLD}Select additional permissions (y/n):${NC}"

    echo -n "CREATEDB (Can create databases)? [y/N]: "
    read answer
    [[ "$answer" =~ ^[Yy]$ ]] && perms+=("CREATEDB")

    echo -n "CREATEROLE (Can create roles)? [y/N]: "
    read answer
    [[ "$answer" =~ ^[Yy]$ ]] && perms+=("CREATEROLE")

    echo -n "REPLICATION (Can initiate replication)? [y/N]: "
    read answer
    [[ "$answer" =~ ^[Yy]$ ]] && perms+=("REPLICATION")

    echo -n "BYPASSRLS (Can bypass row-level security)? [y/N]: "
    read answer
    [[ "$answer" =~ ^[Yy]$ ]] && perms+=("BYPASSRLS")

    echo "${perms[@]}"
}

# ============================================================================
# DATABASE MANAGEMENT FUNCTIONS
# ============================================================================

# Create PostgreSQL database
create_database() {
    local owner="$1"

    print_section "Create Database"

    local dbname=""

    # Get database name
    while true; do
        echo -n -e "\n${BOLD}Enter database name: ${NC}"
        read dbname

        if validate_database_name "$dbname"; then
            if database_exists "$dbname"; then
                print_error "Database '$dbname' already exists"
                continue
            fi
            break
        fi
    done

    # Create database
    print_info "Creating database '$dbname' with owner '$owner'..."

    local create_db_sql="CREATE DATABASE \"$dbname\" OWNER \"$owner\";"

    if execute_sql_quiet "$create_db_sql"; then
        print_success "Database '$dbname' created successfully"

        # Grant privileges
        grant_database_privileges "$dbname" "$owner"

        CREATED_DATABASE="$dbname"
        return 0
    else
        print_error "Failed to create database '$dbname'"
        return 1
    fi
}

# Grant database privileges
grant_database_privileges() {
    local dbname="$1"
    local username="$2"

    print_section "Grant Database Privileges"

    echo -e "${BOLD}Choose privilege level:${NC}"
    echo -e "${CYAN}[1]${NC} ALL PRIVILEGES (Full access - recommended for development)"
    echo -e "${CYAN}[2]${NC} Custom (Select specific privileges)"

    while true; do
        echo -n -e "\n${BOLD}Enter choice [1-2]: ${NC}"
        read priv_choice

        case $priv_choice in
            1)
                print_info "Granting all privileges on database '$dbname' to '$username'..."
                execute_sql_quiet "GRANT ALL PRIVILEGES ON DATABASE \"$dbname\" TO \"$username\";"
                print_success "All privileges granted"
                return 0
                ;;
            2)
                grant_custom_privileges "$dbname" "$username"
                return 0
                ;;
            *)
                print_error "Invalid choice"
                ;;
        esac
    done
}

# Grant custom database privileges
grant_custom_privileges() {
    local dbname="$1"
    local username="$2"
    local privs=()

    echo -e "\n${BOLD}Select privileges to grant (y/n):${NC}"

    echo -n "CONNECT (Can connect to database)? [Y/n]: "
    read answer
    [[ ! "$answer" =~ ^[Nn]$ ]] && privs+=("CONNECT")

    echo -n "CREATE (Can create schemas)? [Y/n]: "
    read answer
    [[ ! "$answer" =~ ^[Nn]$ ]] && privs+=("CREATE")

    echo -n "TEMPORARY (Can create temp tables)? [y/N]: "
    read answer
    [[ "$answer" =~ ^[Yy]$ ]] && privs+=("TEMPORARY")

    if [[ ${#privs[@]} -eq 0 ]]; then
        print_warning "No privileges selected"
        return 1
    fi

    local priv_string=$(IFS=,; echo "${privs[*]}")

    print_info "Granting privileges: $priv_string"
    execute_sql_quiet "GRANT $priv_string ON DATABASE \"$dbname\" TO \"$username\";"
    print_success "Privileges granted"
}

# ============================================================================
# OUTPUT FUNCTIONS
# ============================================================================

# Display summary and Prisma URL
display_summary() {
    local username="$1"
    local password="$2"
    local dbname="$3"

    print_section "Summary"

    echo ""
    echo -e "${BOLD}Database Created Successfully!${NC}"
    echo ""
    echo -e "${CYAN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${BOLD}Connection Details${NC}                                      ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC} Host:     ${GREEN}localhost${NC}                                     ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} Port:     ${GREEN}5432${NC}                                          ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} Database: ${GREEN}$dbname${NC}$(printf '%*s' $((45 - ${#dbname})) '')${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} Username: ${GREEN}$username${NC}$(printf '%*s' $((45 - ${#username})) '')${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} Password: ${GREEN}$password${NC}$(printf '%*s' $((45 - ${#password})) '')${CYAN}│${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────┘${NC}"

    echo ""
    echo -e "${BOLD}${YELLOW}Prisma DATABASE_URL:${NC}"
    echo ""

    local prisma_url="postgresql://${username}:${password}@localhost:5432/${dbname}?schema=public"
    echo -e "${GREEN}${prisma_url}${NC}"

    echo ""
    echo -e "${BOLD}${BLUE}For Docker containers on the same network:${NC}"
    local docker_url="postgresql://${username}:${password}@postgres:5432/${dbname}?schema=public"
    echo -e "${GREEN}${docker_url}${NC}"

    echo ""
    print_info "Copy the URL above and add it to your .env file as DATABASE_URL"
    echo ""
}

# ============================================================================
# MAIN PROGRAM
# ============================================================================

main() {
    print_header

    # Check container status
    check_container

    # Main menu
    print_section "User Selection"
    echo -e "${BOLD}Choose an option:${NC}"
    echo -e "${CYAN}[1]${NC} Create new user"
    echo -e "${CYAN}[2]${NC} Use existing user"
    echo -e "${CYAN}[3]${NC} Exit"

    while true; do
        echo -n -e "\n${BOLD}Enter choice [1-3]: ${NC}"
        read main_choice

        case $main_choice in
            1)
                # Create new user
                if create_new_user; then
                    break
                else
                    print_error "Failed to create user"
                    exit 1
                fi
                ;;
            2)
                # Use existing user
                list_users
                if select_existing_user; then
                    # For existing user, we don't have the password
                    # We'll need to ask for it
                    echo -n -e "\n${BOLD}Enter password for user '$SELECTED_USER': ${NC}"
                    read -s USER_PASSWORD
                    echo ""
                    break
                else
                    print_warning "User selection cancelled"
                    exit 0
                fi
                ;;
            3)
                print_info "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid choice"
                ;;
        esac
    done

    # Create database
    if create_database "$SELECTED_USER"; then
        # Display summary
        display_summary "$SELECTED_USER" "$USER_PASSWORD" "$CREATED_DATABASE"
    else
        print_error "Failed to create database"
        exit 1
    fi

    print_success "All done!"
}

# Run main program
main
