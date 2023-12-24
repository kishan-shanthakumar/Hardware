// elu(...): Exponential Linear Unit.
// exponential(...): Exponential activation function.
// gelu(...): Applies the Gaussian error linear unit (GELU) activation function.
// hard_sigmoid(...): Hard sigmoid activation function.
// linear(...): Linear activation function (pass-through).
// mish(...): Mish activation function.
// relu(...): Applies the rectified linear unit activation function.
// selu(...): Scaled Exponential Linear Unit (SELU).
// sigmoid(...): Sigmoid activation function, sigmoid(x) = 1 / (1 + exp(-x)).
// softmax(...): Softmax converts a vector of values to a probability distribution.
// softplus(...): Softplus activation function, softplus(x) = log(exp(x) + 1).
// softsign(...): Softsign activation function, softsign(x) = x / (abs(x) + 1).
// swish(...): Swish activation function, swish(x) = x * sigmoid(x).
// tanh(...): Hyperbolic tangent activation function.

function sigmoid;
    input logic [63:0] inp;
    input logic [63:0] alpha;
    logic [63:0] sigmoid;
    logic [63:0] temp;
    if(inp[62] == 1'b0)
        sigmoid = inp;
    else
    begin
        
    end
    return sigmoid;
endfunction