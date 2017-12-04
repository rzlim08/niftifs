classdef test_array_funs< matlab.unittest.TestCase
    properties
        fs;
    end
    methods(TestMethodSetup)
        function createFigure(testCase)
            path_to_test_case = fileparts(fileparts(mfilename('fullpath')));
            testCase.fs = NiftiFS([path_to_test_case filesep 'Test_Data' filesep 'soren']);
            assert(exist([path_to_test_case filesep 'Test_Data' filesep 'soren'], 'dir')>0)
            set_functional_dirstruct(testCase.fs, ['{top_level}' filesep '{subjects}' filesep 'Unnamed*' filesep '{runs}' filesep '{scans}']);
            set_subject_strmatch(testCase.fs, 'Ca*');
            set_run_strmatch(testCase.fs, 'fMRI_S*');
            set_scan_strmatch(testCase.fs, '20*.nii');
            set_structural_dirstruct(testCase.fs, ['{top_level}' filesep '{subjects}' filesep 'Unnamed*' filesep 'Cor*' filesep 'co*.nii']);
            
        end
        function test_subjects(testCase)
            set_subjects(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.subjects,1), 4);
        end
        function test_runs(testCase)
            set_runs(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.path_to_runs,1), 8);
        end
    end
    methods(Test)
        
        function test_add_subject(testCase)
            Subject = testCase.fs.subject_array.pop_subject;
            sa = SubjectArray();
            sa.add(Subject);
            testCase.verifyEqual(size(sa.subjects,1), 1);
        end
        function test_add_duplicate_subject(testCase)
            Subject = testCase.fs.subject_array.pop_subject;
            sa = SubjectArray();
            sa.add(Subject);
            sa.add(Subject);
            testCase.verifyEqual(size(sa.subjects,1), 1);
        end
        function test_add_multiple_subject(testCase)
            Subject = testCase.fs.subject_array.pop_subject;
            Subject2 = testCase.fs.subject_array.pop_subject;
            Subject3 = testCase.fs.subject_array.pop_subject;
            sa = SubjectArray();
            sa.add(Subject);
            sa.add(Subject2);
            sa.add(Subject3);
            testCase.verifyEqual(size(sa.subjects,1), 3);
        end
        function test_get_ids(testCase)
            Subject = testCase.fs.subject_array.pop_subject;
            Subject2 = testCase.fs.subject_array.pop_subject;
            Subject3 = testCase.fs.subject_array.pop_subject;
            sa = SubjectArray();
            sa.add(Subject);
            sa.add(Subject2);
            sa.add(Subject3);
            testCase.verifyEqual(size(sa.subjects,1), 3);
            testCase.verifyEqual(size(sa.get_ids,1), 3);
        end
        function test_remove(testCase)
            Subject = testCase.fs.subject_array.pop_subject;
            Subject2 = testCase.fs.subject_array.pop_subject;
            Subject3 = testCase.fs.subject_array.pop_subject;
            sa = SubjectArray();
            sa.add(Subject);
            sa.add(Subject2);
            sa.add(Subject3);
            testCase.verifyEqual(size(sa.subjects,1), 3);
            testCase.verifyEqual(size(sa.get_ids,1), 3);
            sa.remove('Careap101');
            
            testCase.verifyEqual(size(sa.subjects,1), 2);
        end
        function test_remove_strmatch(testCase)
            Subject = testCase.fs.subject_array.pop_subject;
            Subject2 = testCase.fs.subject_array.pop_subject;
            Subject3 = testCase.fs.subject_array.pop_subject;
            sa = SubjectArray();
            sa.add(Subject);
            sa.add(Subject2);
            sa.add(Subject3);
            testCase.verifyEqual(size(sa.subjects,1), 3);
            testCase.verifyEqual(size(sa.get_ids,1), 3);
            sa.remove_strmatch('Careap101');
            testCase.verifyEqual(size(sa.subjects,1), 2);
            sa.remove_strmatch('Careap');
            testCase.verifyEqual(size(sa.subjects,1), 0);
        end
        function test_get_runs(testCase)
            Subject = testCase.fs.subject_array.pop_subject;
            Subject2 = testCase.fs.subject_array.pop_subject;
            Subject3 = testCase.fs.subject_array.pop_subject;
            sa = SubjectArray();
            sa.add(Subject);
            sa.add(Subject2);
            sa.add(Subject3);
            testCase.verifyEqual(size(sa.get_runs,1), 6);
        end
        function test_make_KV(testCase)
            
            set_functional_scans(testCase.fs);
            Subject = testCase.fs.subject_array.pop_subject;
            Subject2 = testCase.fs.subject_array.pop_subject;
            Subject3 = testCase.fs.subject_array.pop_subject;
            sa = SubjectArray();
            sa.add(Subject);
            sa.add(Subject2);
            sa.add(Subject3);
            sa.make_KV;
            testCase.verifyTrue(logical(exist('KV_subjects.mat', 'file')));
        end
    end
    
end