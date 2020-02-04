using System;
using System.Diagnostics;
using WebService.DataTypesInterfaces;
namespace ML {

    public class Model {

        public string Image {
            get; set;
        }

        public Model(string photo) {
            this.Image = photo;
        }
/*
        public int[] PredictsL { get; private set; }
        public int[] PredictsR { get; private set; }
        public int XMin { get; private set; }
        public int YMin { get; private set; }
        public int XMax { get; private set; }
        public int YMax { get; private set; }*/
        public Flag LeftFlag{ get; set; }
        public Flag RightFlag { get; set; }
        private Flag GetFlagFromLine(string line) {
            string[] data = line.Split(' ');
            int leftTopCoordX = Int32.Parse(data[0]);
            int leftTopCoordY = Int32.Parse(data[1]);
            int rightBotomCoordX = Int32.Parse(data[2]);
            int rightBotomCoordY = Int32.Parse(data[3]);
            float[] prob = new float[7];
            for(int i = 4; i < 11; ++i)
            {
                prob[i] = float.Parse(data[i]);
            }
            Flag flag = new Flag();
            // TODO
            return flag;
        }
        public void Run() {
            Process proc = new Process {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "path to python.exe",
                    Arguments = "path to .py",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    CreateNoWindow = true
                }
            };
            string[] line = new string[18];
			proc.Start();
			while (!proc.StandardOutput.EndOfStream){
                // Пока думаю, что выходом будет 2 строки, для левого и для правого флага соответственно
                // Выход в таком формате: leftTopCoordX leftTopCoordY rightBotomCoordX rightBotomCoordY prob1 prob2 prob3 prob4 prob5 prob6 prob7
                line = proc.StandardOutput.ReadLine().Split(' ');
			}
			proc.Close();
            if(line.Length == 0) { return; }
            // TODO
			/*XMin = Int32.Parse(line[0]);
			YMin = Int32.Parse(line[1]);
            XMax = Int32.Parse(line[2]);
            YMax = Int32.Parse(line[3]);

            for (int i = 0; i < 7; i++)
				PredictsL[i] = Int32.Parse(line[i + 5]);

            for (int i = 0; i < 7; i++)
				PredictsR[i] = Int32.Parse(line[i + 11]);*/
        }
	}
}

