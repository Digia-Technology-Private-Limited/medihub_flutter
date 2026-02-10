class ApiConstants {
  // Shopify Store Configuration
  static const String storeName = 'digia-health-template';
  static const String accessToken = '7d599deb8ecdd5dd2f0590c171b13c0a';
  static const String baseUrl =
      'https://$storeName.myshopify.com/api/2025-07/graphql.json';

  // Headers
  static Map<String, String> get headers => {
        'x-shopify-storefront-access-token': accessToken,
        'content-type': 'application/json',
      };

  // GraphQL Queries
  static const String getAllProductsQuery = '''
    query MyQuery {
      products(first: 100) {
        edges {
          node {
            id
            description
            availableForSale
            images(first: 10) {
              edges {
                node {
                  id
                  url
                }
              }
            }
            priceRange {
              maxVariantPrice {
                amount
                currencyCode
              }
              minVariantPrice {
                amount
                currencyCode
              }
            }
            compareAtPriceRange {
              maxVariantPrice {
                amount
                currencyCode
              }
              minVariantPrice {
                amount
                currencyCode
              }
            }
            title
            handle
            featuredImage {
              url
            }
            variants(first: 10) {
              edges {
                node {
                  id
                  title
                  price {
                    amount
                    currencyCode
                  }
                  compareAtPrice {
                    amount
                    currencyCode
                  }
                }
              }
            }
            metafields(identifiers: [
              {namespace: "reviews", key: "rating"},
              {namespace: "reviews", key: "rating_count"}
            ]) {
              key
              namespace
              value
              type
            }
          }
        }
      }
    }
  ''';

  static const String getCollectionsQuery = '''
    query MyQuery(\$first: Int!) {
      collections(first: \$first) {
        edges {
          node {
            handle
            id
            image {
              url
            }
            title
          }
        }
      }
    }
  ''';

  static const String getCollectionByHandleQuery = '''
    query MyQuery(\$handle: String!) {
      collectionByHandle(handle: \$handle) {
        id
        handle
        title
        products(first: 50) {
          edges {
            node {
              id
              handle
              title
              description
              availableForSale
              featuredImage {
                url
              }
              priceRange {
                minVariantPrice {
                  amount
                  currencyCode
                }
                maxVariantPrice {
                  amount
                  currencyCode
                }
              }
              compareAtPriceRange {
                maxVariantPrice {
                  amount
                  currencyCode
                }
                minVariantPrice {
                  amount
                  currencyCode
                }
              }
              variants(first: 10) {
                nodes {
                  title
                  id
                  price {
                    amount
                    currencyCode
                  }
                  compareAtPrice {
                    amount
                    currencyCode
                  }
                }
              }
              metafield(namespace: "custom", key: "gender") {
                value
                type
                key
              }
              metafields(identifiers: [
                {namespace: "reviews", key: "rating"},
                {namespace: "reviews", key: "rating_count"}
              ]) {
                key
                namespace
                value
                type
              }
            }
          }
        }
      }
    }
  ''';

  static const String getProductByHandleQuery = '''
    query ProductByHandle(\$handle: String!) {
      productByHandle(handle: \$handle) {
        id
        title
        handle
        description
        descriptionHtml
        tags
        featuredImage {
          url
          altText
        }
        images(first: 5) {
          nodes {
            url
            altText
            id
          }
        }
        variants(first: 10) {
          nodes {
            id
            title
            availableForSale
            sku
            price {
              amount
              currencyCode
            }
            compareAtPrice {
              amount
              currencyCode
            }
            image {
              url
            }
            selectedOptions {
              name
              value
            }
          }
        }
        priceRange {
          maxVariantPrice {
            amount
            currencyCode
          }
          minVariantPrice {
            amount
            currencyCode
          }
        }
        compareAtPriceRange {
          maxVariantPrice {
            amount
            currencyCode
          }
          minVariantPrice {
            amount
            currencyCode
          }
        }
        metafields(identifiers: [
          {namespace: "custom", key: "product_subtitle"},
          {namespace: "custom", key: "manufacturer"},
          {namespace: "reviews", key: "rating"},
          {namespace: "reviews", key: "rating_count"}
        ]) {
          key
          namespace
          value
          type
        }
      }
    }
  ''';

  static const String createCartMutation = '''
    mutation CreateCart(\$variantId: ID!, \$quantity: Int!) {
      cartCreate(input: {lines: [{quantity: \$quantity, merchandiseId: \$variantId}]}) {
        cart {
          id
          checkoutUrl
          totalQuantity
          lines(first: 10) {
            edges {
              node {
                id
                quantity
                merchandise {
                  ... on ProductVariant {
                    id
                    title
                    price {
                      amount
                      currencyCode
                    }
                    compareAtPrice {
                      amount
                      currencyCode
                    }
                    image {
                      url
                      altText
                    }
                    product {
                      id
                      title
                      handle
                    }
                  }
                }
                cost {
                  amountPerQuantity {
                    amount
                    currencyCode
                  }
                  totalAmount {
                    amount
                    currencyCode
                  }
                  compareAtAmountPerQuantity {
                    amount
                    currencyCode
                  }
                }
              }
            }
          }
        }
        userErrors {
          field
          message
        }
      }
    }
  ''';

  static const String getCartQuery = '''
    query GetCart(\$cartId: ID!) {
      cart(id: \$cartId) {
        id
        checkoutUrl
        totalQuantity
        cost {
          subtotalAmount {
            amount
            currencyCode
          }
          totalAmount {
            amount
            currencyCode
          }
        }
        lines(first: 20) {
          edges {
            node {
              id
              quantity
              merchandise {
                ... on ProductVariant {
                  id
                  title
                  price {
                    amount
                    currencyCode
                  }
                  compareAtPrice {
                    amount
                    currencyCode
                  }
                  image {
                    url
                    altText
                  }
                  product {
                    title
                    handle
                  }
                }
              }
              cost {
                amountPerQuantity {
                  amount
                  currencyCode
                }
                totalAmount {
                  amount
                  currencyCode
                }
                compareAtAmountPerQuantity {
                  amount
                  currencyCode
                }
              }
            }
          }
        }
        discountCodes {
          code
          applicable
        }
        discountAllocations {
          discountedAmount {
            amount
            currencyCode
          }
        }
      }
    }
  ''';

  static const String addToCartMutation = '''
    mutation AddToCart(\$cartId: ID!, \$variantId: ID!, \$quantity: Int!) {
      cartLinesAdd(
        cartId: \$cartId
        lines: [{quantity: \$quantity, merchandiseId: \$variantId}]
      ) {
        cart {
          id
          checkoutUrl
          totalQuantity
          lines(first: 10) {
            edges {
              node {
                id
                quantity
                cost {
                  amountPerQuantity {
                    amount
                    currencyCode
                  }
                  totalAmount {
                    amount
                    currencyCode
                  }
                  compareAtAmountPerQuantity {
                    amount
                    currencyCode
                  }
                }
                merchandise {
                  ... on ProductVariant {
                    id
                    title
                    image {
                      url
                      altText
                    }
                    product {
                      id
                      title
                    }
                  }
                }
              }
            }
          }
        }
        userErrors {
          field
          message
        }
      }
    }
  ''';

  static const String updateCartItemsMutation = '''
    mutation UpdateCart(\$cartId: ID!, \$lines: [CartLineUpdateInput!]!) {
      cartLinesUpdate(cartId: \$cartId, lines: \$lines) {
        cart {
          id
          totalQuantity
          lines(first: 10) {
            edges {
              node {
                id
                quantity
                cost {
                  totalAmount {
                    amount
                    currencyCode
                  }
                }
                merchandise {
                  ... on ProductVariant {
                    id
                    title
                    image {
                      url
                      altText
                    }
                    product {
                      id
                      title
                    }
                  }
                }
              }
            }
          }
        }
        userErrors {
          field
          message
        }
      }
    }
  ''';
}
