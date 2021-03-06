﻿using Business.Objects.Layer.Interfaces.AutoMapper;
using Business.Objects.Layer.Pocos.Reflection;

namespace Business.Objects.Layer.Models.TaskRunner
{
    public class TaskRunnerPropertyModel : IMapTo<PropertyWithValue>
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public string Value { get; set; }
    }
}