define splunk::ta::input (
  $ta,
  $attributes={},
) {

  concat::fragment { "splunk::ta::input::${ta}::${name}:":
    target  => "splunk::ta::inputs_${ta}",
    content => template('splunk/ta/_input.erb'),
    order   => '10',
  }
}


