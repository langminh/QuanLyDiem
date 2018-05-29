using QuanLyDiem.UC.UC1;
using QuanLyDiem.UC.UC3;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyDiem
{
    public partial class AdminFrm : Form
    {
        public AdminFrm()
        {
            InitializeComponent();
            btnQuanLyMonHoc.selected = true;
            mainPanel.Controls.Clear();
            mainPanel.Controls.Add(new UC_QuanLyMonHoc());
        }

        private void bunifuImageButton1_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void bunifuImageButton2_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        private void bunifuImageButton3_Click(object sender, EventArgs e)
        {
            if(menuPanel.Width== 54)
            {
                menuPanel.Width = 235;
                bunifuImageButton3.Location = new Point(199, 10);
                panel1.Height = 130;
                lbName.Visible = true;
                lbTile.Visible = true;
                ptbLogo.Visible = true;
               // bunifuTransition2.ShowSync(menuPanel);
            }
            else
            {
                menuPanel.Width = 54;
                bunifuImageButton3.Location = new Point(12, 10);
                panel1.Height = 53;
                lbName.Visible = false;
                lbTile.Visible = false;
                ptbLogo.Visible = false;
                //bunifuTransition1.ShowSync(menuPanel);
            }
        }

        private void btnQuanLyMonHoc_Click(object sender, EventArgs e)
        {
            mainPanel.Controls.Clear();
            mainPanel.Controls.Add(new UC_QuanLyMonHoc());
        }

        private void bunifuFlatButton2_Click(object sender, EventArgs e)
        {
            mainPanel.Controls.Clear();
            mainPanel.Controls.Add(new UC_QuanLyLop());
        }

        private void bunifuFlatButton3_Click(object sender, EventArgs e)
        {
            mainPanel.Controls.Clear();
            mainPanel.Controls.Add(new UC_QuanLyHoSoHocSinh());
        }

        private void bunifuFlatButton4_Click(object sender, EventArgs e)
        {
            mainPanel.Controls.Clear();
            mainPanel.Controls.Add(new UC_QuanLyGiaoVien());
        }

        private void bunifuFlatButton1_Click(object sender, EventArgs e)
        {
            mainPanel.Controls.Clear();
            mainPanel.Controls.Add(new UC_PhanCongGiangDay());
        }
    }
}
