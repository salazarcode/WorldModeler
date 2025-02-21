using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Core.Entities
{
    public class DProperty
    {
        public string Key { get; set; }
        public string Name { get; set; }
        public string TypeID { get; set; }
        public bool IsArray { get; set; }
    }
}
