# Private defined type called by splunk::addon
#
define splunk::addon::input (
  $addon,
  $attributes={},
) {

  assert_private()

  concat::fragment { "splunk::addon::input::${addon}::${name}:":
    target  => "splunk::addon::inputs_${addon}",
    content => template('splunk/addon/_input.erb'),
    order   => '10',
  }
}


