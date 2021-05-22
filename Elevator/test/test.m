classdef test < matlab.uitest.TestCase
    properties
        f1app
        f2app
        f3app
        e1app
        e2app
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            %rename each .m and .mlapp files 
testCase.f1app=ButtonPanel_f1;
testCase.f2app=ButtonPanel_f2;
testCase.f3app=ButtonPanel_f3;
testCase.e1app=ButtonPanel_e;
testCase.e2app=ButtonPanel_e;
c=ElevatorController;
elev=Elevator;
fS=FloorSensor;
dS=DoorSensor;
eS=EmergSensor;

%change e1app's position
testCase.e1app.UIFigure.Position(1)=testCase.e1app.UIFigure.Position(1)-296;

%set ElevatorController.m's properties
c.f1=testCase.f1app;
c.f2=testCase.f2app;
c.f3=testCase.f3app;
c.e1=testCase.e1app;
c.e2=testCase.e2app;
c.elevator=elev;
c.fSensor=fS;
c.dSensor=dS;
c.emSensor=eS;

%set Elevator.m's properties
elev.f1=testCase.f1app;
elev.f2=testCase.f2app;
elev.f3=testCase.f3app;
elev.e1=testCase.e1app;
elev.e2=testCase.e2app;
elev.control=c;
elev.fSensor=fS;

%set the .mlapp files' properties
testCase.f1app.control=c;
testCase.f2app.control=c;
testCase.f3app.control=c;
testCase.e1app.control=c;
testCase.e1app.fSensor=fS;
testCase.e2app.control=c;
testCase.e2app.fSensor=fS;

%set the ButtonPanel_e tags
testCase.e1app.num=1;
testCase.e1app.EditField.Value='Elevator 1';
testCase.e2app.num=2;
testCase.e2app.EditField.Value='Elevator 2';

%set the time of passing half floor to each ButtonPanel_e 
elev.etime=elev.floor_height/2/elev.speed;
            testCase.addTeardown(@delete,testCase.e2app);
            testCase.addTeardown(@delete,testCase.e1app);
            testCase.addTeardown(@delete,testCase.f3app);
            testCase.addTeardown(@delete,testCase.f2app);
            testCase.addTeardown(@delete,testCase.f1app);
        end
    end
    methods (Test)
        function test_elevator(testCase)
            %�Ե���1Ϊ����չʾ����1���水ť�Ĺ��ܡ����������վ�ڵ���1���棬����
            %����һ¥����¥����¥����¥��һ¥�İ�ť���õ���1�߸����ء�
            pause(1);
            %���ڵ��ݱ�����ͣ��1¥����1��İ�ť��û�з�Ӧ�ġ���ֹ�˿ͷ����������
            testCase.press(testCase.e1app.Button_1);
            pause(3);
            testCase.press(testCase.e1app.Button_2);
            testCase.press(testCase.e1app.Button_3);
            testCase.press(testCase.e1app.Button_2);
            testCase.press(testCase.e1app.Button_1);
            %չʾ�������ȥ���˵�Ч�����Ȱѵ���2������¥��
            testCase.press(testCase.e2app.Button_2);
            pause(3);
            %������¥�ġ����¡���ť���ȽϽ��ĵ���2������¥��
            testCase.press(testCase.f3app.downButton);
            %���¶�¥�ġ����ϡ���ť������1������¥��������1��һ¥������2��
            %��¥�����������������һ�������ƶ���һ�����У�������Ĭ���ƶ��ĵ���1����
            testCase.press(testCase.f2app.upButton);
            %����һ¥�ġ����ϡ���ť���ȽϽ��ĵ���1����2¥��
            testCase.press(testCase.f1app.upButton);
            pause(1);
            %�Ե���1Ϊ����չʾ������ͣ��ʱ�Ŀ��Ű�ťЧ����
            testCase.press(testCase.e1app.openButton);
            %�Ե���2Ϊ����չʾ������ͣ��ʱ�Ľ�����ťЧ����
            testCase.press(testCase.e2app.EmergencyButton);
        end
        
    end
    
    
    
end