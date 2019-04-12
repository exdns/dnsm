defmodule Dnsm.MixProject do
  use Mix.Project

  def project do
    [
      app: :dnsm,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      language: :erlang,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:erlbase32, github: "exdns/erlbase32"},
      {:asn1, github: "exdns/asn1"},
      {:recase, "~> 0.4.0"}
    ]
  end
end
