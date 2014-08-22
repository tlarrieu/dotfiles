function todo
  cat ~/todo.tasks 2> /dev/null | ponysay
end

function vitodo
  vim ~/todo.tasks
end
