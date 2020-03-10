/**
 *
 * Group Categories Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { Formik, Form, Field, FieldArray } from 'formik';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import Select from 'components/Shared/DiverstSelect';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Group/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, Paper, Typography,
  TextField, Hidden, FormControl, Divider, Switch, FormControlLabel,
} from '@material-ui/core';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import dig from "object-dig";

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function GroupCategoriesFormInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.group}>
      <Card>
        <Formik
          initialValues={{ catgory_labels: [] }}
          onSubmit={values => setTimeout(() => {
            alert(JSON.stringify(values, null, 2));
          }, 500)
          }
          render={({ values }) => (
            <Form>
              <CardContent>
                <Field
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  disabled={props.isCommitting}
                  id='name'
                  name='name'
                  margin='normal'
                  label='Category Name'
                  value={values.name}
                />
                <Typography>Category Labels </Typography>
                <br />
                <FieldArray
                  name='catgory_labels'
                  render={arrayHelpers => (
                    <div>
                      {values.catgory_labels && values.catgory_labels.length > 0 ? (
                        values.catgory_labels.map((friend, index) => (
                          // eslint-disable-next-line react/no-array-index-key
                          <div key={index}>
                            <Field name={`catgory_labels.${index}`} />
                            <button
                              type='button'
                              onClick={() => arrayHelpers.remove(index)} // remove a friend from the list
                            >
                              -
                            </button>
                            <button
                              type='button'
                              onClick={() => arrayHelpers.insert(index, '')} // insert an empty string at a position
                            >
                              +
                            </button>
                          </div>
                        ))
                      ) : (
                        <button type='button' onClick={() => arrayHelpers.push('')}>
                          {/* show this when user has removed all friends from the list */}
                          Add a Category
                        </button>
                      )}
                    </div>
                  )}
                />
              </CardContent>
              <Divider />
              <CardActions>
                <DiverstSubmit isCommitting={props.isCommitting}>
                  {buttonText}
                </DiverstSubmit>
                <Button
                  disabled={props.isCommitting}
                  // to={props.links.cancelLink}
                  component={dig(props, 'links', 'cancelLink') ? WrappedNavLink : 'button'}
                >
                  <DiverstFormattedMessage {...messages.cancel} />
                </Button>
              </CardActions>
            </Form>
          )}
        />
      </Card>
    </DiverstFormLoader>
  );
}

export function GroupCategoriesForm(props) {
  const initialValues = buildValues(props.group, {
    name: { default: '' },
    short_description: { default: '' },
    description: { default: '' },
    parent: { default: '', customKey: 'parent_id' },
    children: { default: [], customKey: 'child_ids' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupAction(mapFields(values, ['child_ids', 'parent_id']));
      }}
    >
      {formikProps => <GroupCategoriesFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

GroupCategoriesForm.propTypes = {
  edit: PropTypes.bool,
  groupAction: PropTypes.func,
  group: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

GroupCategoriesFormInner.propTypes = {
  edit: PropTypes.bool,
  group: PropTypes.object,
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  selectGroups: PropTypes.array,
  getGroupsBegin: PropTypes.func,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupCategoriesForm);
