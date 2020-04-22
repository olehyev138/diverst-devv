/**
 *
 * subgroup join Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { Field, Formik, Form } from 'formik';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/GlobalSettings/EnterpriseConfiguration/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, FormControl, Divider, Switch, FormControlLabel,
} from '@material-ui/core';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function SubgroupJoinFormInner({ classes, handleSubmit, handleChange, values, handleClose, ...props }) {
  return (
    <Form>
      <Grid container>
        {values.children && values.children.map((subgroup, i) => (
          <Grid item key={subgroup.id} xs={12}>
            <FormControl>
              <FormControlLabel
                labelPlacement='right'
                label={subgroup.name}
                control={(
                  <Field
                    component={Switch}
                    onChange={handleChange}
                    color='primary'
                    id='current_user_is_member'
                    name='current_user_is_member'
                    margin='normal'
                    checked={values.children[i].current_user_is_member}
                    value={values.current_user_is_member}
                  />
                )}
              />
            </FormControl>
          </Grid>
        ))}
        <Grid item xs='12'>
          <Grid container justify='flex-end'>
            <Button
              color='primary'
              type='submit'
            >
            Done
            </Button>
            <Button onClick={handleClose}>
              <DiverstFormattedMessage {...messages.cancel} />
            </Button>
          </Grid>
        </Grid>
      </Grid>
    </Form>
  );
}

export function SubgroupJoinForm(props) {
  const initialValues = buildValues(props.group, {
    id: { default: '' },
    name: { default: '' },
    children: { default: [] }
  });
  console.log(props.group);
  return (
    <React.Fragment>
      <Formik
        initialValues={initialValues}
        enableReinitialize
        onSubmit={(values, actions) => {
          props.subgroupJoinAction(mapFields(values, ['children']));
        }}
      >
        {formikProps => <SubgroupJoinFormInner handleClose={props.handleClose} {...props} {...formikProps} />}
      </Formik>
    </React.Fragment>
  );
}

SubgroupJoinForm.propTypes = {
  handleClose: PropTypes.func,
  subgroupJoinAction: PropTypes.func,
  group: PropTypes.object,
};

SubgroupJoinFormInner.propTypes = {
  handleClose: PropTypes.func,
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  values: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(SubgroupJoinForm);
