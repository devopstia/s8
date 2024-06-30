sed -i 's|POSTGRES_VERSION|v1.1.0|g' a.yaml
## =================================================================
sed -i 's/POSTGRES_VERSION/v1.1.0/g' a.yaml
sed -i 's/MYSQL_VERSION/v1.1.0/g' a.yaml
sed -i 's/POSTGRES_PASSWORD_CRED/80ew9CQ>qa=j}#38qDMJ/g' a.yaml
sed -i 's/MYSQL_ROOT_PASSWORD_CRED/k%hKqMaTk9N)eo%hW^R%/g' a.yaml

cat a.yaml

## =================================================================

export POSTGRES_PASSWORD_CRED="80ew9CQ>qa=j}#38qDMJ"
export MYSQL_ROOT_PASSWORD_CRED="k%hKqMaTk9N)eo%hW^R"

echo $POSTGRES_PASSWORD_CRED
echo $MYSQL_ROOT_PASSWORD_CRED

## =================================================================

sed -i "s/POSTGRES_VERSION/v1.1.0/g" a.yaml
sed -i "s/MYSQL_VERSION/v1.1.0/g" a.yaml
sed -i "s/POSTGRES_PASSWORD_CRED/$POSTGRES_PASSWORD_CRED/g" a.yaml
sed -i "s/MYSQL_ROOT_PASSWORD_CRED/$MYSQL_ROOT_PASSWORD_CRED/g" a.yaml

cat a.yaml

## =================================================================
sed -i "s|POSTGRES_VERSION|v1.1.0|g" a.yaml
sed -i "s|MYSQL_VERSION|v1.1.0|g" a.yaml
sed -i "s|POSTGRES_PASSWORD_CRED|$POSTGRES_PASSWORD_CRED|g" a.yaml
sed -i "s|MYSQL_ROOT_PASSWORD_CRED|$MYSQL_ROOT_PASSWORD_CRED|g" a.yaml

cat a.yaml