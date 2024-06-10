#include <stdexcept>
#include <string>

class SemError : public std::runtime_error {
public:
    explicit SemError(const std::string& message)
        : std::runtime_error(message) {}
};