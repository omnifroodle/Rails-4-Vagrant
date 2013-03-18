## The puppet-pick module

This module ONLY features a function named 'pick' that acts as data-lookup pattern in Puppet.  For example, what if you wanted to define a parameter in the Puppet Enterprise Console (or Puppet Dashboard) that would be used as an override for a data lookup (like [Hiera](http://github.com/puppetlabs/hiera), for example).  You would want to use the Console parameter if it existed, but fail-over to the Hiera lookup.

Use the function like the following:

<pre>
  $result = pick($::console_parameter, hiera('hiera_parameter', 'default'))
  notify { "The resultant parameter value is: ${result}": }
</pre>

The pick function would first look for a top-scope variable called 'console\_parameter'. Because Console parameters become top-scope variables in Puppet, if a parameter called 'console\_parameter' existed, the pick function would return that value.  Failing that, it would do a Hiera lookup for a parameter called 'hiera\_parameter'.  Failing THAT, it would default to the value of 'default'.  The above code assumes you had Hiera installed.  If you wanted to failover to another variable, you could do the following:

<pre>
  $result = pick($::console_parameter, $local_variable)
  notify { "The resultant parameter value is: ${result}": }
</pre>

In this case, Puppet would fail over to the value in the variable called $local\_variable
