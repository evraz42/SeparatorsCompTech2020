namespace ML {

	public class Model {	

		public string photo {
			get; set;
		};

		public Model(string photo) {
			this.photo = photo;
		}

		public int[] PredictsL{ get; set; };
		public int[] PredictsR{ get; set; };
		public int Num { get; set; };
		public int xMin { get; set; };
		public int yMin { get; set; };
		public int xMax { get; set; };
		public int yMax { get; set; };

		public void run() {
            Process proc = new Process();
			var proc = new Process {
			    StartInfo = new ProcessStartInfo
			    {
			        FileName = "path to python.exe",
			        Arguments = "path to .py"
			        UseShellExecute = false,
			        RedirectStandardOutput = true,
			        CreateNoWindow = true
			    }
			};
			int[] line;
			proc.Start();
			while (!proc.StandardOutput.EndOfStream){
			    line = proc.StandardOutput.ReadLine().Split(' ');
			}
			proc.Close();

			xMin = line[0];
			yMin = line[1];
			xMax = line[2];
			yMax = line[3];

			for (int i = 0; i < 7; i++)
				PredictsL[i] = line[i + 5];
		
			for (int i = 0; i < 7; i++)
				PredictsR[i] = line[i + 11];
		}
	}
}

