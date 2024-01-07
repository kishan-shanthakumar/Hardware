// Resolution
// Time period
// Duty cycle
// Dead time
// Enable
// Prescaler
// Edge-aligned, Center Aligned, One Shot Mode

module pwm_accelerator (
    input logic en, clk, n_reset,
    input axi4lite_MOSI_t slave_in,
    output axi4lite_MISO_t slave_out,
    input logic trigger,
    output logic pwm
);

logic [15:0] prescaler;
logic [4:0] resolution;
logic [15:0] time_period;
logic [15:0] duty_cycle;
logic [15:0] dead_time;
logic [3:0] mode;

// PWM action
logic clk_local;
logic [15:0] clk_counter;
logic [15:0] resolved_time_period;
logic [15:0] resolved_prescaler;
logic [15:0] time_period_local;

assign resolved_prescaler = (resolution[4] == 1) ? prescaler >> 4 :
                            (resolution[3] == 1) ? prescaler >> 3 :
                            (resolution[2] == 1) ? prescaler >> 2 :
                            (resolution[1] == 1) ? prescaler >> 1 :
                            prescaler >> 0;

assign resolved_time_period = (resolution[4] == 1) ? time_period << 4 :
                              (resolution[3] == 1) ? time_period << 3 :
                              (resolution[2] == 1) ? time_period << 2 :
                              (resolution[1] == 1) ? time_period << 1 :
                              time_period << 0;

always_ff @( posedge clk, negedge n_reset )
begin
    if (!n_reset)
    begin
        clk_local <= 0;
        clk_counter <= 0;
        time_period_local <= 0;
    end
    else
    begin
        if ((clk_counter + 1) == resolved_prescaler)
        begin
            clk_counter <= 0;
            clk_local <= ~clk_local;
        end
        else
            clk_counter <= clk_counter + 1;
        if (clk_local)
        begin
            if (time_period_local == time_period)
                time_period_local <= 0;
            else
                time_period_local <= time_period_local + 1;
        end
    end
end

endmodule