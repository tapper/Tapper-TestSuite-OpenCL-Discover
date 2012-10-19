package OpenCL::Discover;

use common::sense;
use OpenCL;

use base 'Exporter';

our @EXPORT_OK = qw(discover);



sub discover
{
        my @platforms;
        foreach my $platform (OpenCL::platforms) {
                my @devices;
                foreach my $device ($platform->devices (OpenCL::DEVICE_TYPE_ALL)) {
                        my %result_device;
                        if ($device->type & OpenCL::DEVICE_TYPE_GPU) {
                                $result_device{device_type} = 'GPU';
                        } elsif ($device->type & OpenCL::DEVICE_TYPE_CPU) {
                                $result_device{device_type} = 'CPU';
                        }elsif ($device->type & OpenCL::DEVICE_TYPE_ACCELERATOR) {
                                $result_device{device_type} = 'ACCELERATOR';
                        }
                        $result_device{vendor} = $device->vendor;
                        $result_device{extensions} = [split /\s+/, $device->extensions];
                        $result_device{device_available} = $device->available;
                        $result_device{profile} = $device->profile;
                        $result_device{opencl_version} = $device->version;
                        $result_device{driver_version} = $device->driver_version;
                        $result_device{vendor} = $device->vendor;
                        $result_device{vendor_id} = $device->vendor_id;
                        $result_device{number_address_bits} = $device->address_bits;
                        $result_device{compiler_available} = $device->compiler_available;
                        $result_device{double_float_capabilities} = {
                                                                     denorms => $device->double_fp_config & OpenCL::FP_DENORM ? 1 : 0,
                                                                     inf_nan => $device->double_fp_config & OpenCL::FP_INF_NAN ? 1 : 0,
                                                                     round_to_nearest => $device->double_fp_config & OpenCL::FP_ROUND_TO_NEAREST ? 1 : 0,
                                                                     round_to_zero => $device->double_fp_config & OpenCL::FP_ROUND_TO_ZERO ? 1 : 0,
                                                                     round_to_infinity => $device->double_fp_config & OpenCL::FP_ROUND_TO_INF ? 1 : 0,
                                                                     fused_multiply_add => $device->double_fp_config & OpenCL::FP_FMA ? 1 : 0,
                                                                    };
                        $result_device{half_float_capabilities} = {
                                                                     denorms => $device->half_fp_config & OpenCL::FP_DENORM ? 1 : 0,
                                                                     inf_nan => $device->half_fp_config & OpenCL::FP_INF_NAN ? 1 : 0,
                                                                     round_to_nearest => $device->half_fp_config & OpenCL::FP_ROUND_TO_NEAREST ? 1 : 0,
                                                                     round_to_zero => $device->half_fp_config & OpenCL::FP_ROUND_TO_ZERO ? 1 : 0,
                                                                     round_to_infinity => $device->half_fp_config & OpenCL::FP_ROUND_TO_INF ? 1 : 0,
                                                                     fused_multiply_add => $device->half_fp_config & OpenCL::FP_FMA ? 1 : 0,
                                                                    };
                        $result_device{single_float_capabilities} = {
                                                                     denorms => $device->single_fp_config & OpenCL::FP_DENORM ? 1 : 0,
                                                                     inf_nan => $device->single_fp_config & OpenCL::FP_INF_NAN ? 1 : 0,
                                                                     round_to_nearest => $device->single_fp_config & OpenCL::FP_ROUND_TO_NEAREST ? 1 : 0,
                                                                     round_to_zero => $device->single_fp_config & OpenCL::FP_ROUND_TO_ZERO ? 1 : 0,
                                                                     round_to_infinity => $device->single_fp_config & OpenCL::FP_ROUND_TO_INF ? 1 : 0,
                                                                     fused_multiply_add => $device->single_fp_config & OpenCL::FP_FMA ? 1 : 0,
                                                                    };
                        $result_device{endian_little} = $device->endian_little;
                        $result_device{memory_error_correction} =  $device->error_correction_support ? 1 : 0;
                        $result_device{exec_capabilities} = {
                                                             opencl_kernel_support => $device->execution_capabilities  & OpenCL::EXEC_KERNEL ? 1 : 0,
                                                             native_kernel_support => $device->execution_capabilities  & OpenCL::EXEC_NATIVE_KERNEL ? 1 : 0,
                                                            };
                        if ($device->global_mem_cache_size & OpenCL::NONE) {
                                $result_device{global_memory_cache_byte} = 'none';
                        } elsif ($device->global_mem_cache_size & OpenCL::READ_ONLY_CACHE) {
                                $result_device{device_type} = 'read_only';
                        }elsif ($device->global_mem_cache_size & OpenCL::READ_WRITE_CACHE) {
                                $result_device{device_type} = 'read_write';
                        }

                        $result_device{global_mem_cache_line_byte} = $device->global_mem_cacheline_size;
                        $result_device{global_memory_byte}         = $device->global_mem_size;
                        $result_device{unified_mem}                = $device->host_unified_memory;
                        if ($device->image_support) {
                                $result_device{image_support} = {
                                                                 image2d_max_height   => $device->image2d_max_height,
                                                                 image2d_max_width    => $device->image2d_max_width,
                                                                 image3d_max_height   => $device->image3d_max_height,
                                                                 image3d_max_width    => $device->image3d_max_width,
                                                                 image3d_max_depth    => $device->image3d_max_depth,
                                                                 max_read_image_args  => $device->max_read_image_args,
                                                                 max_write_image_args => $device->max_write_image_args,
                                                                 max_samplers         => $device->max_samplers,
                                                                }
                        } else {
                                $result_device{image_support} = undef;
                        }
                        $result_device{local_mem_size} = $device->local_mem_size;
                        $result_device{has_local_mem} = $device->local_mem_type & OpenCL::LOCAL ? 1 : 0;
                        $result_device{max_frequency_mhz} = $device->max_clock_frequency;
                        $result_device{max_compute_units} = $device->max_compute_units;
                        $result_device{max_constant_args} = $device->max_constant_args;
                        $result_device{max_constant_buffer_byte} = $device->max_constant_buffer_size;
                        $result_device{max_mem_alloc_size} = $device->max_mem_alloc_size;
                        $result_device{max_parameter_size} = $device->max_parameter_size;
                        $result_device{max_work_group_size} = $device->max_work_group_size;
                        $result_device{max_work_item_sizes} = $device->max_work_item_sizes;
                        $result_device{mem_base_addr_align} = $device->mem_base_addr_align;
                        $result_device{min_data_type_align_size} = $device->min_data_type_align_size;
                        $result_device{queue_properties} = {
                                                            out_of_order_exec_mode => $device->properties & OpenCL::QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE ? 1 : 0,
                                                            profiling => $device->properties & OpenCL::QUEUE_PROFILING_ENABLE ? 1 : 0,
                                                           };
                        $result_device{profiling_timer_resolution}  = $device->profiling_timer_resolution;
                        $result_device{preferred_vector_width_half} = $device->preferred_vector_width_half;
                        $result_device{native_vector_width} = {
                                                               char    => $device->native_vector_width_char,
                                                               short   => $device->native_vector_width_short,
                                                               int     => $device->native_vector_width_int,
                                                               long    => $device->native_vector_width_long,
                                                               float   => $device->native_vector_width_float,
                                                               double  => $device->native_vector_width_double,
                                                               half    => $device->native_vector_width_half,
                                                              };

                        push @devices, \%result_device;
                }
                my %result_platform = ( devices => \@devices );
                $result_platform{profile} = $platform->profile;
                push @platforms, \%result_platform;
        }
        return \@platforms;

}

1;
