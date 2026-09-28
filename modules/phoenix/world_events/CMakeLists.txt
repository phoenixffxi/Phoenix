target_sources(xi_map PRIVATE ${CMAKE_CURRENT_LIST_DIR}/world_events.cpp)
target_link_libraries(xi_map PRIVATE httplib::httplib nlohmann_json::nlohmann_json)
