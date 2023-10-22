defmodule ServiceDiscovery.MixProject do
  use Mix.Project

  def project do
    [
      app: :service_discovery,
      version: "0.1.0",
      escript: escript(),
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ServiceDiscovery, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:grpc, "~> 0.7"},
      {:protobuf, "~> 0.11"},
      {:google_protos, "~> 0.1"},
    ]
  end

  defp escript do
    [main_module: ServiceDiscovery]
  end
end
