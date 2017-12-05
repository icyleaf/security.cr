class String
  def shellescape
    str = to_s
    return "''".dup if str.empty?

    str = str.dup
    str = str.gsub /([^A-Za-z0-9_\-.,:\/@\n])/, "\\\\\\1"
    str = str.gsub /\n/, "'\n'"

    return str
  end
end
