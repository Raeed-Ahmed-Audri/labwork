%% Calculate TE101 and TE102 Modes using theoretical Eqns.

a = 23e-3;                          
b = 10.2e-3;
d = 28.2*10^-3;
c = 3*10^8;
cond = 2.564*10^7;
permeability_free_space = 4*pi*10^-7;
permittivity_free_space = 8.85418782 * 10^-12;

eta = sqrt(permeability_free_space/ permittivity_free_space);

fc101 = c/(2*pi)*sqrt((pi/a)^2+(0*pi/b)^2+(pi/d)^2);

fc102 = c/(2*pi)*sqrt((pi/a)^2+(0*pi/b)^2+(2*pi/d)^2)

k101 = sqrt((pi/a)^2+(0*pi/b)^2+(pi/d)^2);
k102 = sqrt((pi/a)^2+(0*pi/b)^2+(2*pi/d)^2);

Rs101 = sqrt(2*pi*fc101*permeability_free_space/(2*cond));
Rs102 = sqrt(2*pi*fc102*permeability_free_space/(2*cond));

Q101 = (k101*a*d)^3*b*eta/(2*pi^2*Rs101)*(1/(2*1^2*a^3*b + 2*b*d^3 + 1^2*a^3*d + a*d^3));
Q102 = (k102*a*d)^3*b*eta/(2*pi^2*Rs102)*(1/(2*2^2*a^3*b + 2*b*d^3 + 2^2*a^3*d + a*d^3));

%% Two-port: f0, loaded Q (-3 dB points), insertion loss for TE101 and TE102
clc; close all;
S2p = load('2 port.s2p');                % two-port cavity measurement
freq2  = S2p(:,1);                       % Hz
S21_db = S2p(:,4);                       % |S21| in dB

% Theory values from section 1 (same cavity dimensions)
modes   = {'TE101', 'TE102'};
f_theo  = [fc101, fc102];                % theoretical resonant frequencies, Hz
Q_theo  = [Q101,  Q102];                 % theoretical unloaded Q

for m = 1:2
    % Window around the theoretical resonance
    win   = (freq2 >= f_theo(m) - 0.5e9) & (freq2 <= f_theo(m) + 0.5e9);
    f_w   = freq2(win);
    S21_w = S21_db(win);

    % f0 = peak of |S21|
    [S21_pk, j0] = max(S21_w);
    f0 = f_w(j0);

    % -3 dB points relative to the peak (Appendix C)
    lvl = S21_pk - 3;
    [~, jL] = min(abs(S21_w(1:j0)   - lvl));
    [~, jR] = min(abs(S21_w(j0:end) - lvl));
    f1 = f_w(jL);
    f2 = f_w(j0 - 1 + jR);
    QL = f0/(f2 - f1);

    % Insertion loss at resonance
    IL = -S21_pk;                        % dB, positive

    % Coupling factor and unloaded Q (manual Appendix B)
    G0 = 10^(-IL/20);                    % |Gamma(f0)| = sqrt(10^(-IL/10))
    K  = (1 + G0)/(1 - G0);
    QU = QL*(1 + K);

    % Print results
    fprintf('\n--- Two-port %s ---\n', modes{m});
    fprintf('f0 = %.6f GHz, |S21(f0)| = %.2f dB\n', f0/1e9, S21_pk);
    fprintf('f1 = %.6f GHz, f2 = %.6f GHz, df = %.3f MHz\n', f1/1e9, f2/1e9, (f2 - f1)/1e6);
    fprintf('QL = %.0f\n', QL);
    fprintf('Insertion loss = %.2f dB\n', IL);
    fprintf('f0: measured = %.4f GHz, theory = %.4f GHz, error = %+.2f %%\n', ...
            f0/1e9, f_theo(m)/1e9, (f0 - f_theo(m))/f_theo(m)*100);
    fprintf('K = %.3f, QU = %.0f, theory = %.0f, error = %+.1f %%\n', ...
            K, QU, Q_theo(m), (QU - Q_theo(m))/Q_theo(m)*100);

    % Plot
    figure; plot(f_w/1e9, S21_w); grid on; hold on
    yline(lvl, '--k', '-3 dB from peak');
    plot(f0/1e9, S21_pk, 'ro', 'MarkerFaceColor', 'r');
    plot([f1 f2]/1e9, [lvl lvl], 'bs', 'MarkerFaceColor', 'b');
    xlabel('Frequency (GHz)'); ylabel('|S21| (dB)');
    title(sprintf('Two-port %s: f_0 = %.4f GHz, Q_L = %.0f', modes{m}, f0/1e9, QL));
end