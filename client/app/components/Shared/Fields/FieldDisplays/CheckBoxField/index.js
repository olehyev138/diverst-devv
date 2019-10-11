/**
 *
 * CheckBoxField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import dig from 'object-dig';
import { connect, Field, getIn } from 'formik';

import { List, ListItem, Typography } from '@material-ui/core';

const CustomCheckBox = (props) => {
  const { classes } = props;

  const fieldDatum = dig(props, 'fieldDatum');
  const fieldDatumIndex = dig(props, 'fieldDatumIndex');

  // allow specification of dataLocation
  const dataLocation = props.dataLocation || `fieldData.${fieldDatumIndex}.data`;

  return (
    <div>
      <Typography variant='h5' component='h2' className={classes.dataHeaders}>
        {fieldDatum.field.title}
      </Typography>
      <Typography component='h2'>
        <List component='nav'>
          {JSON.parse(fieldDatum.data).map((datum, i) => (
            // eslint-disable-next-line react/no-array-index-key
            <ListItem key={`fieldData${fieldDatum.id}-${i}`}>
              - {datum}
            </ListItem>
          ))}
        </List>
      </Typography>
    </div>
  );
};

CustomCheckBox.propTypes = {
  classes: PropTypes.object,
  fieldDatum: PropTypes.shape({
    data: PropTypes.string,
  }),
  fieldDatumIndex: PropTypes.number,
  dataLocation: PropTypes.string,
};

export default connect(CustomCheckBox);
