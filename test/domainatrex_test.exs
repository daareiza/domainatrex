defmodule DomainatrexTest do
  use ExUnit.Case
  doctest Domainatrex

  test "1 dot domains" do
    assert Domainatrex.parse("domainatrex.com") == {:ok, %{domain: "domainatrex", subdomain: "", tld: "com"}}
  end

  test "2 dot domains" do
    assert Domainatrex.parse("zen.id.au") == {:ok, %{domain: "zen", subdomain: "", tld: "id.au"}}
  end

  test "subdomains" do
    assert Domainatrex.parse("my.blog.zen.id.au") == {:ok, %{domain: "zen", subdomain: "my.blog", tld: "id.au"}}
  end

  test "s3" do
    assert Domainatrex.parse("s3.amazonaws.com") == {:ok, %{domain: "amazonaws", subdomain: "s3", tld: "com"}}
  end

  test "custom suffix" do
    assert Domainatrex.parse("s3.amazonaws.localhost") == {:ok, %{domain: "amazonaws", subdomain: "s3", tld: "localhost"}}
  end

  ##  bd : https://en.wikipedia.org/wiki/.bd
  ## *.bd
  test "domains with wildcard" do
    assert Domainatrex.parse("www.techtunes.com.bd") == {:ok, %{domain: "techtunes", subdomain: "www", tld: "com.bd"}}
    assert Domainatrex.parse("www.techtunes.bd") == {:ok, %{domain: "techtunes", subdomain: "www", tld: "bd"}}
    assert Domainatrex.parse("send.kawasaki.jp") == {:ok, %{domain: "send", subdomain: "", tld: "kawasaki.jp"}}
    assert Domainatrex.parse("www.send.kawasaki.jp") == {:ok, %{domain: "send", subdomain: "www", tld: "kawasaki.jp"}}
    assert Domainatrex.parse("www.elb.send.kawasaki.jp") == {:ok, %{domain: "elb", subdomain: "www", tld: "send.kawasaki.jp"}}
  end

  test "nonsense" do
    assert Domainatrex.parse("nonsense") == {:error, "Cannot parse: invalid domain"}
  end

  test "unicode punnycode" do
    assert Domainatrex.parse("xn--h1afdfc2d.xn--p1ai") == {:ok, %{domain: "xn--h1afdfc2d", subdomain: "", tld: "xn--p1ai"}}
  end

  test "real unicode" do
    assert Domainatrex.parse("шломин.рф") == {:ok, %{domain: "шломин", subdomain: "", tld: "рф"}}
  end

  test "valid pubblic suffix without domain" do
    ["ca.us", "fl.us", "or.us"]
    |> Enum.each(fn domain ->
      assert Domainatrex.parse(domain) == {:error, "Cannot parse: invalid domain"}
    end)

  end
end
