defmodule Dnsm do
  @moduledoc false

  [from: "./include/dns_records.hrl"]
  |> Record.extract_all()
  |> Enum.map(fn {record_name, record_info} ->
    defmodule Module.concat([Recase.to_pascal(Atom.to_string(record_name))]) do
      @moduledoc false

      keys = :lists.map(&elem(&1, 0), record_info)
      vals = :lists.map(&{&1, [], nil}, keys)
      pairs = :lists.zip(keys, vals)

      defstruct record_info
      @type t :: %__MODULE__{}

      def to_record(%__MODULE__{unquote_splicing(pairs)}) do
        {unquote(record_name), unquote_splicing(vals)}
      end

      @doc """
      Converts a `:dns_rr` record into a `DnsMessage.Rr`.
      """
      def from_record(file_info)

      def from_record({unquote(record_name), unquote_splicing(vals)}) do
        %__MODULE__{unquote_splicing(pairs)}
      end
    end
  end)

  @doc """

  """
  def to_record(%{__struct__: struct_name} = struct) do
    struct
    |> Map.delete(:__struct__)
    |> Enum.map(fn {k, v} -> {k, to_record(v)} end)
    |> Map.new()
    |> Map.merge(%{__struct__: struct_name})
    |> struct_name.to_record()
  end

  def to_record(other) when is_list(other) do
    Enum.map(other, &to_record/1)
  end

  def to_record(other), do: other

  @doc """

  """
  def from_record(record) when is_tuple(record) do
    [record_name | record_field_list] = :erlang.tuple_to_list(record)
    new_record = :erlang.list_to_tuple([record_name | Enum.map(record_field_list, &from_record/1)])
    apply(generate_module_name(record_name), :from_record, [new_record])
  end

  def from_record(field_list) when is_list(field_list) do
    Enum.map(field_list, &from_record/1)
  end

  def from_record(field), do: field

  @doc """

  """
  def generate_module_name(record_name) do
    Module.concat([
      record_name
      |> Atom.to_string()
      |> Recase.to_pascal()
    ])
  end

  # __end_of_module__
end
