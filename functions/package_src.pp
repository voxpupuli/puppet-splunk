# @summary
#   Builds the default source URL for the Splunk Forwarder or Enterprise
#   installation media, from splunk::params::src_root plus the given
#   version/build.
#
# @api private
function splunk::package_src(
  Enum['forwarder', 'enterprise'] $product,
  String[1] $version,
  String[1] $build,
) >> String[1] {
  $suffix = splunk::package_suffix($facts['os']['family'], $facts['os']['architecture'], $version, $build)

  case $product {
    'forwarder': {
      $product_dir    = 'universalforwarder'
      $os_subdir      = $splunk::params::forwarder_src_subdir
      $package_prefix = 'splunkforwarder'
    }
    'enterprise': {
      $product_dir    = 'splunk'
      $os_subdir      = $splunk::params::enterprise_src_subdir
      $package_prefix = 'splunk'
    }
    default: {
      fail("unsupported splunk::package_src product ${product}")
    }
  }

  "${splunk::params::src_root}/products/${product_dir}/releases/${version}/${os_subdir}/${package_prefix}-${suffix}"
}
