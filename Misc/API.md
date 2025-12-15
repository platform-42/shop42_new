# Test Shopify API token


## Orders
``` 
curl \
--header "Content-Type: application/json" \
--header "Accept: application/json" \
--header "X-Shopify-Access-Token: shpua_99c965f6577be2fea481bf45ccfbfef8" \
-X GET \
https://cephlon.myshopify.com/admin/api/2022-01/orders.json?financial_status=pending&created_at_min=2024-01-11T00:00:00.000Z&fields=current_total_price&limit=100
``` 

# Order details - after date
``` 
curl \
--header "Content-Type: application/json" \
--header "Accept: application/json" \
--header "X-Shopify-Access-Token: shpua_160eedfdeb4ace7fc5dc366230c18322" \
-X GET "https://cephlon.myshopify.com/admin/api/2022-10/orders.json?status=any&created_at_min=2024-08-11T00:00:00.000Z&fields=created_at,%20current_total_price&limit=5"
``` 
