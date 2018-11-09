defmodule Facebook.ApiBehaviour do
  @type respnose :: {integer, map} | {:error, String.t()}

  @callback request(String.t()) :: respnose
end
