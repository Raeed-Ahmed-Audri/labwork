%Angles
angles = [-90:10:90];
CoPolar_E    = [-72.4 -68.8 -62.7 -60.1 -57 -55 -42.7 -39.5 -35.4 -33.4 -34.5 -37.81 -40.4 -46.1 -51 -53.1 -57.4 -61.3 -63];
CrossPolar_E = [-68 -71.2 -64.6 -62 -59 -65.2 -58.6 -48.7 -45.2 -45.18 -47.8 -52.81 -60.3 -62.6 -72.13 -74.35 -74.46 -75.1 -68.3];
CoPolar_H    = [-52.1 -49 -57.2 -48.6 -49.7 -55 -49.7 -40.5 -35.3 -34.3 -34.7 -39.8 -44.2 -50.6 -51 -51.2 -57.3 -54.8 -57.7];
CrossPolar_H = [-65.3 -63.1 -61.3 -52.37 -60.1 -59 -56.3 -52 -46.4 -46.5 -48 -55.8 -61.2 -63.12 -60.2 -62.1 -64.3 -61 -62.5];

%Finding the Zero degree index
angle = 0;
ref_angle_position = find(ismember(angles,angle));

%Normalization
CoPolar_E_norm = CoPolar_E - CoPolar_E(ref_angle_position);
CoPolar_H_norm = CoPolar_H - CoPolar_H(ref_angle_position);
CrossPolar_E_norm = CrossPolar_E - CoPolar_E(ref_angle_position);
CrossPolar_H_norm = CrossPolar_H - CoPolar_H(ref_angle_position);

%Converting to linear (mW)
P_CoPolar_E  = 10.^(CoPolar_E_norm/10);
P_CoPolar_H  = 10.^(CoPolar_H_norm/10);
P_CrossPolar_E  = 10.^(CrossPolar_E_norm/10);
P_CrossPolar_H  = 10.^(CrossPolar_H_norm/10);

%Cartesian Plot
%% E-plane
figure
plot(angles,CoPolar_E_norm,...
    angles, CrossPolar_E_norm, "linewidth", 1.5);
grid on
set(gca, 'FontSize', 11, 'FontName', "Times")
xticks(-90:30:90);
xlabel('$\mathrm{Degrees}\ (^\circ)$', 'Interpreter', 'latex')
ylabel('$\mathrm{Normalized\ power\ (dB)}$', "Interpreter", "latex")
title("E-Plane")
lgd = legend({'$\mathrm{Co\mbox{-}Polar\ E\mbox{-}Plane\ Normalized}$', ...
              '$\mathrm{Cross\mbox{-}Polar\ E\mbox{-}Plane\ Normalized}$'});
lgd.Interpreter = 'latex';

print('E_plot.jpg', '-djpeg', '-r300')

%% H-Plane
figure
plot(angles,CoPolar_H_norm,...
    angles, CrossPolar_H_norm, "linewidth", 1.5);
grid on
set(gca, 'FontSize', 11, 'FontName', "Times")
xlabel('$\mathrm{Degrees}\ (^\circ)$', 'Interpreter', 'latex')
ylabel('$\mathrm{Normalized\ power\ (dB)}$', "Interpreter", "latex")
title("H-Plane")
lgd = legend({'$\mathrm{Co\mbox{-}Polar\ H\mbox{-}Plane\ Normalized}$', ...
              '$\mathrm{Cross\mbox{-}Polar\ H\mbox{-}Plane\ Normalized}$'});
lgd.Interpreter = 'latex';
xticks(-90:30:90);
print('H_plot.jpg', '-djpeg', '-r300')



% Polar Plot in Linear
%% E-plane polar (linear, normalized)
close all
figure
polarplot(deg2rad(angles), P_CoPolar_E, '-o', 'LineWidth', 1.5, 'MarkerSize', 4);
hold on
polarplot(deg2rad(angles), P_CrossPolar_E, '--s', 'LineWidth', 1.5, 'MarkerSize', 4);
hold off
grid on
pax = gca;
pax.ThetaZeroLocation = 'top';
pax.ThetaDir = 'clockwise';
%pax.ThetaLim = [-90 90];
pax.RLim = [0 1];
pax.ThetaTick = 0:30:330;
pax.ThetaTickLabel = {'0','30','60','90','120','150','180', ...
                      '-150','-120','-90','-60','-30'};
pax.RAxisLocation = 180;   % moves the radial numbers to the empty bottom, off the main lobe
pax.FontSize = 11;
pax.TickLabelInterpreter = 'latex';
title('$\mathrm{E\mbox{-}Plane\ Radiation\ Pattern\ (Normalized\ Linear\ Power)}$', 'Interpreter', 'latex')
lgd = legend({'$\mathrm{Co\mbox{-}Polar\ E\mbox{-}Plane}$', ...
              '$\mathrm{Cross\mbox{-}Polar\ E\mbox{-}Plane}$'});
lgd.Interpreter = 'latex';
lgd.Location = 'southoutside';
print('E_polar.jpg', '-djpeg', '-r300')

%% H-plane polar (linear, normalized)
figure
polarplot(deg2rad(angles), P_CoPolar_H, '-o', 'LineWidth', 1.5, 'MarkerSize', 4);
hold on
polarplot(deg2rad(angles), P_CrossPolar_H, '--s', 'LineWidth', 1.5, 'MarkerSize', 4);
hold off
pax = gca;
pax.ThetaZeroLocation = 'top';
pax.ThetaDir = 'clockwise';
%pax.ThetaLim = [-90 90];
pax.RLim = [0 1];
pax.ThetaTick = 0:30:330;
pax.ThetaTickLabel = {'0','30','60','90','120','150','180', ...
                      '-150','-120','-90','-60','-30'};
pax.RAxisLocation = 180;   % moves the radial numbers to the empty bottom, off the main lobe
pax.FontSize = 11;
pax.TickLabelInterpreter = 'latex';
title('$\mathrm{H\mbox{-}Plane\ Radiation\ Pattern\ (Normalized\ Linear\ Power)}$', 'Interpreter', 'latex')
lgd = legend({'$\mathrm{Co\mbox{-}Polar\ H\mbox{-}Plane}$', ...
              '$\mathrm{Cross\mbox{-}Polar\ H\mbox{-}Plane}$'});
lgd.Interpreter = 'latex';
lgd.Location = 'southoutside';
print('H_polar.jpg', '-djpeg', '-r300')

%% HPBW
[HPBW_E, aL_E, aR_E] = hpbw(angles, CoPolar_E_norm, ref_angle_position);
[HPBW_H, aL_H, aR_H] = hpbw(angles, CoPolar_H_norm, ref_angle_position);

fprintf('E-plane: -3 dB at %.1f and %.1f deg, HPBW = %.1f deg\n', aL_E, aR_E, HPBW_E);
fprintf('H-plane: -3 dB at %.1f and %.1f deg, HPBW = %.1f deg\n', aL_H, aR_H, HPBW_H);

function [bw, aL, aR] = hpbw(ang, pdB, i0)
    % Right side: first point at or after 0 deg that is below -3 dB
    iR = find(pdB(i0:end) < -3, 1) + i0 - 1;
    % Left side: last point at or before 0 deg that is below -3 dB
    iL = find(pdB(1:i0) < -3, 1, 'last');

    if isempty(iR) || isempty(iL)
        bw = NaN; aL = NaN; aR = NaN;   % pattern never fell below -3 dB
        return
    end

    % Linear interpolation between the two points bracketing -3 dB
    aR = ang(iR-1) + (-3 - pdB(iR-1)) * (ang(iR) - ang(iR-1)) / (pdB(iR) - pdB(iR-1));
    aL = ang(iL)   + (-3 - pdB(iL))   * (ang(iL+1) - ang(iL)) / (pdB(iL+1) - pdB(iL));

    bw = aR - aL;
end