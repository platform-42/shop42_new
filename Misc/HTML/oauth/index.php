<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopify Authorization</title>
    <link rel="stylesheet" href="shops42.css">
</head>

<body>
    <header>
        <div class="header">
            <h1>Shops42</h1>
        </div>
    </header>

    <section>
        <div class="section">
            <p>
                <img src="shops42.jpg" alt="Shops42 logo">
            </p>
            <h2>Shopify Authorization</h2>
            <p>
                Shopify has granted application Shops42 access to
                sales, order, customer, product, and security information.
                By signing-out, access be revoked.
            </p>
            <hr />
            <p>
                Press Okay button to enable Shopify dashboards on your Apple watch
            </p>
            <p>
                <!-- <a href="<?php echo "shops42://oauth/shopify/?" . $_SERVER['QUERY_STRING']; ?>"> -->
                <a href="shops42://oauth/shopify/">
                    Okay
                </a>
            </p>
            <p>
                YOU EXPRESSLY ACKNOWLEDGE AND AGREE THAT USE OF THE LICENSED APPLICATION IS AT YOUR SOLE RISK
            </p>
        </div>
    </section>

    <footer>
        <div class="footer">
            <p class="footer">
                Copyright(C) Platform-42.com, 2024
            </p>
        </div>
    </footer>
</body>
</html>
