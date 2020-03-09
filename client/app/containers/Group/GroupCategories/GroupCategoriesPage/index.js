/**
 *
 * GroupCategoriesPage
 *
 */
import React, { memo, useEffect, useState } from 'react';
import {
  Typography
} from '@material-ui/core';
import { compose } from 'redux';


export function GroupCategoriesPage(props) {
  return (
    // eslint-disable-next-line react/react-in-jsx-scope
    <Typography>this is Group Categories Page</Typography>
  );
}
export default compose(
  memo,
)(GroupCategoriesPage);
