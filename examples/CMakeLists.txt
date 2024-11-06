project(msp_examples)

# testing publish/subscribe
add_executable(fcu_test src/fcu_test.cpp)
target_link_libraries(fcu_test PRIVATE msp::fcu)

# test setting motors directly
add_executable(fcu_motors src/fcu_motor_test.cpp)
target_link_libraries(fcu_motors PRIVATE msp::fcu)

# subscribing with custom type
add_executable(fcu_custom_type src/fcu_custom_type.cpp)
target_link_libraries(fcu_custom_type PRIVATE msp::fcu)

# client test for asynchronous callbacks
add_executable(client_async_test src/client_async_test.cpp)
target_link_libraries(client_async_test PRIVATE msp::client)

# client test for blocking read
add_executable(client_read_test src/client_read_test.cpp)
target_link_libraries(client_read_test PRIVATE msp::client)
