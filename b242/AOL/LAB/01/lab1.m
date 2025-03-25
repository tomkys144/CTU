LAB1 = readtable("LAB1.xlsx");
%%
figure; clf; cla; hold on;
plot(LAB1.ULED1V, LAB1.If,'LineWidth',2);
plot(LAB1.ULED2V, LAB1.If,'LineWidth',2);
plot(LAB1.ULED3V, LAB1.If,'LineWidth',2);
plot(LAB1.ULED4V, LAB1.If,'LineWidth',2);
plot(LAB1.ULED5V, LAB1.If,'LineWidth',2);
plot(LAB1.ULED6V, LAB1.If,'LineWidth',2);
plot(LAB1.ULED7V, LAB1.If,'LineWidth',2);
legend("LED1", "LED2", "LED3", "LED4", "LED5", "LED6", "LED7", "Location", "northwest");
xlabel("U [V]"); ylabel("I_f [mA]")
grid on;
hold off;

%% 2

UR3 = 2.5113 - LAB1.UOUTV;
Ic = UR3 / 470 * 1000;

Ic(abs(Ic) < 0.01) = 0;

CTR = Ic./LAB1.If;

figure
hold on
plot(LAB1.UOUTV, LAB1.If,'LineWidth',2);
grid on
hold off
xlabel("U [V]"); ylabel("I_f [mA]")

figure
hold on
plot(LAB1.If, CTR*100, "LineWidth",2);
grid on
hold off
xlabel("I_f [mA]"); ylabel("CTR [%]")