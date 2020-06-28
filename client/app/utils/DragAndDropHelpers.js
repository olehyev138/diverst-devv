/*
Drag and drop helpers
GetListDrop/GetListDrag : Produce a vertical list of draggable CARDS.
 */

import { useDrag, useDrop } from 'react-dnd';
import React from 'react';

const ItemTypes = {
  CARD: 'card',
};

export function getListDrop(index, moveCard, ref) {
  // eslint-disable-next-line react-hooks/rules-of-hooks
  const [, drop] = useDrop({
    accept: ItemTypes.CARD,
    hover(item, monitor) {
      if (!ref.current)
        return;

      const dragIndex = item.index;
      const hoverIndex = index;

      if (dragIndex === hoverIndex)
        return;

      const hoverBoundingRect = ref.current.getBoundingClientRect();
      const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;
      const clientOffset = monitor.getClientOffset();
      const hoverClientY = clientOffset.y - hoverBoundingRect.top;

      if (dragIndex < hoverIndex && hoverClientY < hoverMiddleY)
        return;

      if (dragIndex > hoverIndex && hoverClientY > hoverMiddleY)
        return;

      moveCard(dragIndex, hoverIndex);
      item.index = hoverIndex;
    },
  });
  return drop;
}

export function getListDrag(id, index, draggable) {
  // eslint-disable-next-line react-hooks/rules-of-hooks
  const [{ isDragging }, drag] = useDrag({
    item: { type: ItemTypes.CARD, id, index },
    canDrag: draggable,
    collect: monitor => ({
      isDragging: monitor.isDragging()
    })
  });
  return drag;
}
