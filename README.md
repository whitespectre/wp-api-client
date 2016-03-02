# A read-only Ruby client for WP-API v2

This unambitious client provides read-only access for WP-API v2.

It supports authentication via OAuth.

It does not support comments or POST requests.

It requires **Ruby 2.3** and is tested against **WP-API 2.0-beta12**.

## Installation

```ruby
gem install wp-api-client
```

And

```ruby
require 'wp_api_client'
```

## Usage examples

#### Set up the client and get some posts

```ruby
# create a client

WpApiClient.configure do |api_client|
  api_client.endpoint = 'http://example.com/wp-json/wp/v2'
end

@api = WpApiClient.get_client

# get some posts
posts = @api.get('custom_post_type/') # or "posts/" etc
# => <WpApiClient::Collection:0x007fed432a5660 @resources=[#<WpApiClient::Entities::Post...

posts.map { |p| puts p.title }
# Custom Post Type 99
# Custom Post Type 98
# Custom Post Type 97

term = @posts.first.terms.first
# => #<WpApiClient::Entities::Term:0x007fed42b3e458 @resource={"id"=>2...
```

#### Navigate between posts, terms and taxonomies

```ruby
term.taxonomy
# => #<WpApiClient::Entities::Taxonomy:0x007f9c2c86f1a8 @resource={"name"=>"Custom taxonomy"...

term.posts
# => #<WpApiClient::Collection:0x007fd65d07d588 @resources=[#<WpApiClient::Entities::Post...

# term.posts("custom_post_type").first.terms("category").first.taxonomy... etc etc etc
```

#### Pagination

```ruby
posts = @api.get('posts', page: 2)

posts.count
# => 10

posts.total_available
# => 100

next_page = @api.get(posts.next_page)
# => #<WpApiClient::Collection:0x00bbcafe938827 @resources=[#<WpApiClient::Entities::Post...

page_after_that = @api.get(next_page.page_after_that)
# => #<WpApiClient::Collection:0x00bbcafe938827 @resources=[#<WpApiClient::Entities::Post...
```

#### Loading a taxonomy via a slug

WP-API returns an array even if there's only one result, so you need to be careful here

```ruby
term = @api.get('custom_taxonomy', slug: 'term_one').first
taxonomy_name = term.taxonomy.name
posts = term.posts
```

#### OAuth

Provide a symbol-keyed hash of `token`, `token_secret`, `consumer_key` and `consumer_secret` on configuration.

```ruby
WpApiClient.configure do |api_client|
  api_client.oauth_credentials = oauth_credentials_hash
end

client = WpApiClient.get_client
```

## Testing and compatibility

This library comes with VCR cassettes recorded against a local WP installation
running WP-API v2-beta12. It is not tested with other versions.

To run the tests, invoke `rspec`.

## Structure

### Public Objects

#### `WpApiClient::Client`

Accepts a `WpApiClient::Connection` and exposes a `#get` method.

Pass a URL into `#get` and it will do its best to return usable data.

The second parameter accepts an optional hash of query params.

#### `WpApiClient::Connection`

Initialize with an API endpoint like `http://localhost:8080/wp-json/wp/v2`, then
pass into a new client. Faraday options might be pulled out of here in the future.

### Internal Objects

#### `WpApiClient::Collection`

Wraps a set of `WpApiClient::Entities` in an `Enumerable` interface and provides `next_page`
and `previous_page` methods. Pass these into `@api` and it will give you back the
data you want

```ruby
next_page = @api.get(posts.next_page)
# => #<WpApiClient::Collection:0x00bbcafe938827 @resources=[#<WpApiClient::Entities::Post...
```

#### `WpApiClient::Entities::Base`

Base class for `Post`, `Term`, `Image` and `Taxonomy`, so far. Not all methods are implemented.

## Other

Thanks [WP-API](https://github.com/WP-API/WP-API)!
