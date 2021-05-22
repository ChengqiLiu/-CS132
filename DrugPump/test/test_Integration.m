classdef test_Integration < matlab.uitest.TestCase
    properties
        nur
        pat 
        pump 
        controlsys 
        passwordUI
        paitentUI
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.nur = Nurse;
            testCase.pat = Patient; 
            testCase.pump = Pump;
            testCase.controlsys = Controlsys;

            testCase.passwordUI = PasswordUI;
            testCase.paitentUI = PatientButton;
                        
            testCase.passwordUI.nurse = testCase.nur;
            testCase.passwordUI.pump = testCase.pump;
            testCase.passwordUI.controlsys = testCase.controlsys;

            testCase.nur.PWUI = testCase.passwordUI;
            testCase.nur.pump = testCase.pump;

            testCase.pump.patient = testCase.pat;
            testCase.pump.PWUI = testCase.passwordUI;
            testCase.pump.controlsys = testCase.controlsys;

            testCase.paitentUI.pump = testCase.pump;
            testCase.paitentUI.patient = testCase.pat;

            testCase.pat.button = testCase.paitentUI;
            testCase.pat.pump = testCase.pump;

            testCase.controlsys.pump = testCase.pump;
            testCase.controlsys.passwordUI = testCase.passwordUI;
            testCase.controlsys.patientUI = testCase.paitentUI;

            testCase.addTeardown(@delete,testCase.nur); 
            testCase.addTeardown(@delete,testCase.pat);
            testCase.addTeardown(@delete,testCase.pump);
            testCase.addTeardown(@delete,testCase.controlsys);
            testCase.addTeardown(@delete,testCase.passwordUI); 
            testCase.addTeardown(@delete,testCase.paitentUI); 
        end
    end
    methods (Test)
        function test_SelectButtonPushed(testCase)
            %�������
            testCase.type(testCase.passwordUI.StaffIDEditField,'abcd');
            pause(0.5);
            testCase.type(testCase.passwordUI.PasswordEditField,'1234');
            pause(0.5);
            testCase.press(testCase.passwordUI.ConfirmButton);
            testCase.verifyEqual(testCase.passwordUI.Label.Text,  'Wrong id or password');
            %������룬��NurseUI
            pause(0.5);
            testCase.type(testCase.passwordUI.StaffIDEditField,'9999');
            pause(0.5);
            testCase.type(testCase.passwordUI.PasswordEditField,'9999');
            testCase.verifyEqual(testCase.passwordUI.nurse.ID,testCase.passwordUI.id);
            testCase.verifyEqual(testCase.passwordUI.nurse.password,testCase.passwordUI.password);
            pause(0.5);
            testCase.press(testCase.passwordUI.ConfirmButton);
            pause(1);
            %�����޸���ֵ������Confirm֮���趨��ֵ����ʱ���ز��ܰ���
            testCase.press(testCase.nur.nUIapp.BaselinemlminSpinner,'up');
            testCase.verifyEqual(testCase.nur.nUIapp.Message_13.Text , 'Not Confirmed !');
            pause(0.5);
            testCase.press(testCase.nur.nUIapp.BolusmlshotSpinner,'up');
            testCase.verifyEqual(testCase.nur.nUIapp.Message_13.Text , 'Not Confirmed !');
            pause(0.5);
            testCase.press(testCase.nur.nUIapp.BolusGapminSpinner,'up');
            testCase.verifyEqual(testCase.nur.nUIapp.Message_13.Text , 'Not Confirmed !');
            pause(0.5);
            testCase.press(testCase.nur.nUIapp.ConfirmButton);
            testCase.verifyEqual(testCase.controlsys.nurseUI.PUMPSwitch.Enable , 'on');
            testCase.verifyEqual(testCase.controlsys.pump.baseline , testCase.controlsys.nurseUI.baselineSpeed);
            testCase.verifyEqual(testCase.controlsys.pump.bolus , testCase.controlsys.nurseUI.bolusAmountInfo);
            testCase.verifyEqual(testCase.controlsys.pump.bolusGap , testCase.controlsys.nurseUI.bolusGapInfo);
            testCase.verifyEqual(testCase.controlsys.pump.PressAvailable,1);
            testCase.verifyEqual(testCase.controlsys.pump.gap , 0);
            testCase.verifyEqual(testCase.controlsys.nurseUI.Message_4.Text , num2str(testCase.controlsys.nurseUI.baselineSpeed));
            testCase.verifyEqual(testCase.controlsys.nurseUI.Message_5.Text , num2str(testCase.controlsys.nurseUI.bolusAmountInfo));
            testCase.verifyEqual(testCase.controlsys.nurseUI.Message_6.Text , num2str(testCase.controlsys.nurseUI.bolusGapInfo));
            pause(1);
            %�򿪿���֮�󣬿�ʼע��
            testCase.press(testCase.nur.nUIapp.PUMPSwitch);
            pause(2);
            %��һ��bolus��ע�����ֹʹҩ��������bolus gapʱ���ھͲ����ٰ�,�������ʱ��֮����ֿ�����
            testCase.press(testCase.paitentUI.GetBolusButton);
            pause(1);
            testCase.press(testCase.paitentUI.GetBolusButton);
            pause(0.5);
            testCase.press(testCase.paitentUI.GetBolusButton);
            testCase.verifyEqual(testCase.controlsys.nurseUI.BolusAvailableLamp.Color,[1.00,0.00,0.00]);
            testCase.verifyEqual(testCase.controlsys.patientUI.BolusAvailableLamp.Color,[1.00,0.00,0.00]);
            pause(4.5);
            testCase.verifyEqual(testCase.controlsys.nurseUI.BolusAvailableLamp.Color,[0 1 0]);
            testCase.verifyEqual(testCase.controlsys.patientUI.BolusAvailableLamp.Color,[0 1 0]);
            testCase.press(testCase.paitentUI.GetBolusButton);
            pause(15);
            testCase.verifyEqual(testCase.controlsys.nurseUI.BolusAvailableLamp.Color,[1.00,0.00,0.00]);
            testCase.verifyEqual(testCase.controlsys.patientUI.BolusAvailableLamp.Color,[1.00,0.00,0.00]);
            testCase.verifyEqual(testCase.controlsys.nurseUI.BaselineAvailableLamp.Color,[1.00,0.00,0.00]);
            %ע����;�����޸ġ���ȷ��ǰ��Ч
            testCase.press(testCase.nur.nUIapp.BaselinemlminSpinner,'down');
            testCase.verifyEqual(testCase.nur.nUIapp.Message_13.Text , 'Not Confirmed !');
            pause(4);
            %����confirm����Ч
            testCase.press(testCase.nur.nUIapp.ConfirmButton);
            pause(6);
            
            %����չʾ�ڶ��졢�������ע�������
            %%%%%%%
            pause(140);
            testCase.press(testCase.paitentUI.GetBolusButton);
            pause(4.5);
            %%%%%%%%
            
            %�ص����أ�ע��ֹͣ��
            testCase.press(testCase.nur.nUIapp.PUMPSwitch);
            pause(3);
        end
        
    end
    
end