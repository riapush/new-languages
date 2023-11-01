-- Функция для вычисления значения функции f(x)
function f(x)
    -- Здесь вам нужно определить свою функцию f(x)
    -- Например, f(x) = x^2
    return x^2
end

-- Функция для округления числа до заданной точности
function round(number, precision)
    local factor = 10^precision
    return math.floor(number * factor + 0.5) / factor
end

-- Функция для поиска максимума функции f(x) на отрезке [a, b]
function findMaximum(a, b, epsilon)
    local max_x = a  -- Начальное значение x, где максимум будет искаться
    local max_fx = f(max_x)  -- Значение функции в начальной точке

    local step = (b - a) / 10  -- Начальный шаг, разбиваем отрезок на 10 частей

    while step > epsilon do
        local x = a
        while x <= b do
            local fx = f(x)
            if fx > max_fx then
                max_x = x
                max_fx = fx
            end
            x = x + step
        end
        -- Уменьшаем шаг
        step = step / 10
    end

    -- Округляем значения до заданной точности epsilon
    max_x = round(max_x, -math.log10(epsilon))
    max_fx = round(max_fx, -math.log10(epsilon))

    return max_x, max_fx
end

-- Пример использования
local a = 0
local b = 1
local epsilon = 0.001

local max_x, max_fx = findMaximum(a, b, epsilon)
print("Максимум функции f(x) на отрезке [" .. a .. ", " .. b .. "] равен " .. max_fx .. " и достигается при x = " .. max_x)