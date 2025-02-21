﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Core.Entities
{
    public class DType
    {
        public string Guid { get; set; }
        public string TenantId { get; set; }
        public string Key { get; set; }
        public string Name { get; set; }
        public List<DProperty> Properties { get; set; } = new List<DProperty>();
        public List<DRelation> Relations { get; set; } = new List<DRelation>();
    }
}
